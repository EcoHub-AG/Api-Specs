# Schema Registry GitOps Workflow

This project is based on [schema-registry-gitops](https://github.com/domnikl/schema-registry-gitops), a tool that uses a desired state defined in YAML to configure and manage confluent schema registry — similar to how CRDs (Custom Resource Definitions) work in Kubernetes.

## 🔍 Important Concepts

- In the schema registry, there is a **distinction between subjects and schemas**.  
  A subject refers to a schema under a specific name (often tied to a Kafka topic), while the actual schema can evolve independently. The subject name stays consistent across versions.

---

## ⚙️ Prerequisites

- Java must be available in your system’s `PATH`.
- The [Confluent CLI](https://docs.confluent.io/confluent-cli/current/index.html) must be set up and authenticated to access the schema registry:
  ```bash
  confluent login
  ```
- The `schema-registry-gitops` tool requires a valid **tech user certificate** for an SSL connection:
    1. Obtain the tech user certificate.
    2. Import the certificate into a Java keystore.
    3. Update `gitops.properties` with the relevant keystore configuration.

---

## Schema Registry Subjects
For the purpose of this repository, all the subjects in the registry can be categorized as one of 4 types:
- Base Subjects: These are all schemas that don't have any references, i.e. don't depend on other schemas. This applies to all the schemas in the `event-generic` folder like `ProcessIdType.json`.
- Reference Schemas: This term applies to all subjects that hold event-schema definitions which reference the base subjects.
- Value Schemas: These are the subjects that hold the schemas for the messages in the different topics. These are usually created automatically by EcoHub, but need to be updated if the base subjects change. 
- Key Schemas: These are the subjects for the messages keys for the different subjects. These are not influence by a change in the base subjects and don't need to be updated. 

## 🛠️ Workflow

The complete process is compiled into `gitops.sh`. Alternatively, the individual steps can be executed separately.

### Step 1: Backup Current Registry State

Dump the current registry state for backup or reapplication:

```bash
java -jar schema-registry-gitops.jar --properties=./gitops.properties dump ./registryStateBackup.yaml
```

---

### Step 2: Update Reference Schemas (Base Subjects)

Update the base subjects (schemas that do **not** reference other schemas) to match the files in the repository.

- The desired state is defined in `event-generic-template.yaml`, which contains the definitions for all the base subjects. When a new base subject is added or removed, this file needs to be edited accordingly.
- The individual schemas for the subjects are referenced in the template and are pulled from the repository.

Preview changes:

```bash
java -jar schema-registry-gitops.jar --properties=./gitops.properties plan ./event-generic-template.yaml
```

Apply changes:

```bash
java -jar schema-registry-gitops.jar --properties=./gitops.properties apply ./event-generic-template.yaml
```

---

### Step 3: Get Current Schema Versions

Since we just updated the base subjects, they now have a new version in the registry. We need to retrieve the latest version number for all of the subjects, so it can subsequently used for other schemas that reference the base subjects.

To obtain the latest version numbers, we:

1. Use the confluence cli to list all subjects, excluding those ending in `-key` or `-value`.
2. Save the list to a YAML file.
3. For each subject:
    - Use the Confluent CLI to get all schema versions.
    - Extract the latest version.
    - Store in a new YAML file.
4. Export this file as an environment variable.

---

### Step 4: Update Referencing Schemas

Next, the schemas that depend on the base subjects are updated. The desired state is again defined in `events-state-template.yaml`, but all the version numbers are replaced with the numbers collected in step 3.

Plan and apply:

```bash
java -jar schema-registry-gitops.jar --properties=./gitops.properties plan ./events-state.yaml
java -jar schema-registry-gitops.jar --properties=./gitops.properties apply ./events-state.yaml
```

---

### Step 5: Update `-value` Subjects

Since the latest version number of the reference schemas have changed in the last step, Step 3 must repeated first to get refresh the latest schema versions. Afterwards, all the value subjects are updated. As the value subjects are created and removed automatically by EcoHub, this step is also building the desired state dynamically.

In Detail:

1. Dump the full registry state:
   ```bash
   java -jar schema-registry-gitops.jar --properties=./gitops.properties dump ./currentRegistry.yaml
   ```
2. Filter for `-value` subjects and save to `valueSubjectsState.yaml`.
3. Replace all reference versions with the latest ones.
4. Plan and apply updates:
   ```bash
   java -jar schema-registry-gitops.jar --properties=./gitops.properties plan ./valueSubjectsState.yaml
   java -jar schema-registry-gitops.jar --properties=./gitops.properties apply ./valueSubjectsState.yaml
   ```

---

## 🧹 Clearing the Registry

A helper script is included to **clear all subjects** from the registry. ⚠️ **Use with caution!**

This is useful for restoring backups or resetting schema versions. To run it:

- Provide a valid Confluent API key and secret.

```bash
./clear-registry.sh  # Example usage
```

---

## 📁 Folders

- `cli` — Tools and configuration
- `latestReferenceVersions` — used to get the latest versions in Step 3 and 5
- `updateEvents` — used to update the reference schemas in step 4
- `updateReferenceSchemas` — used to update the base subjects
- `updateValueSubjects` — used to update the `-value` subjects in step 5
