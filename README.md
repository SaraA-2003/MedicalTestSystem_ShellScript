#  Medical Test Management System (Shell Script)

This project is a simple yet functional shell scripting-based system developed on **Ubuntu (Linux)** to manage and retrieve **medical test data** for individual patients. It allows basic patient test record management through a **menu-driven interface** using standard shell utilities.



## Features

- Add a new medical test record
- Search tests by Patient ID
  - Retrieve all tests
  - Retrieve abnormal tests
  - Retrieve tests in a specific period
  - Retrieve tests by status (pending, completed, reviewed)
- Search abnormal results across all patients
- Calculate average test values
- Update test records
- Delete existing test records
- Input validation & error handling



## Technologies Used

- Shell Scripting (Bash)
- Ubuntu (Linux)
- Text files for data storage



## 📂 Project Structure

```
MedicalTest-Management/
├── medicalTest.sh              # Main shell script with all functionalities
├── medicalRecord.txt           # Stores all medical test records
├── medicalTest.txt             # Stores details about test types and normal ranges
├── README.md                   # Project documentation
└── report.pdf                  # Detailed explanation and testing walkthrough (optional)
```
## How to Run the Application

Follow the steps below to set up and run the Medical Test Management System:


### 1. Install Ubuntu (Linux Environment)

If you're not already using Linux:

- Install **Ubuntu** on your machine directly, **or**
- Use a **Virtual Machine** (e.g., VirtualBox) and install Ubuntu inside it



### 2. Install the Project

Clone or download the project files into your Ubuntu system.
```
git clone https://github.com/yourusername/MedicalTest-Management.git](https://github.com/SaraA-2003/MedicalTestSystem_ShellScript.git)
```


### 3. Open the Project Directory

Navigate into the project directory using cd:
```
cd MedicalTest-Management

```

### 4. Give Execute Permission to the Script
Before running, make the script executable:
```
chmod +x main.sh

```

###  5. Run the Application
Run the script using one of the following commands:
```
./medicalTest.sh

```
or
```
sh medicalTest.sh
```
