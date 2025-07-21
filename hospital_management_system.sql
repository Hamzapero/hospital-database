-- SQL script for a Hospital Management System for a city
-- This schema includes tables for patients, doctors, departments, appointments, treatments, medications, staff, rooms, and billing

-- Drop tables if they exist to allow re-creation
DROP TABLE IF EXISTS billing;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS departments;

-- Departments in the hospital
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Patients table
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctors table
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INT NOT NULL REFERENCES departments(department_id) ON DELETE SET NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE,
    specialty VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Staff table (nurses, admin, technicians, etc.)
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(100) NOT NULL,
    department_id INT REFERENCES departments(department_id) ON DELETE SET NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Rooms table
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(20) NOT NULL UNIQUE,
    department_id INT REFERENCES departments(department_id) ON DELETE SET NULL,
    room_type VARCHAR(50), -- e.g., ICU, General, Operation Theater
    capacity INT DEFAULT 1,
    status VARCHAR(20) DEFAULT 'available' -- available, occupied, maintenance
);

-- Appointments table
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    doctor_id INT NOT NULL REFERENCES doctors(doctor_id) ON DELETE SET NULL,
    appointment_date TIMESTAMP NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'scheduled', -- scheduled, completed, cancelled, no-show
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Treatments table
CREATE TABLE treatments (
    treatment_id SERIAL PRIMARY KEY,
    appointment_id INT NOT NULL REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    treatment_description TEXT NOT NULL,
    treatment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- Medications table
CREATE TABLE medications (
    medication_id SERIAL PRIMARY KEY,
    treatment_id INT NOT NULL REFERENCES treatments(treatment_id) ON DELETE CASCADE,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    start_date DATE,
    end_date DATE
);

-- Billing table
CREATE TABLE billing (
    bill_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    appointment_id INT REFERENCES appointments(appointment_id) ON DELETE SET NULL,
    amount NUMERIC(10, 2) NOT NULL,
    billing_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50), -- cash, card, insurance, etc.
    payment_status VARCHAR(20) DEFAULT 'pending' -- pending, paid, cancelled
);

-- Indexes for performance optimization
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_treatments_appointment ON treatments(appointment_id);
CREATE INDEX idx_medications_treatment ON medications(treatment_id);
CREATE INDEX idx_billing_patient ON billing(patient_id);

-- Sample data insertion (optional)
INSERT INTO departments (name, description) VALUES 
('Cardiology', 'Heart related treatments'), 
('Neurology', 'Brain and nervous system'), 
('Emergency', 'Emergency care'),
('Orthopedics', 'Bone and joint care'),
('Pediatrics', 'Child healthcare');

INSERT INTO patients (first_name, last_name, date_of_birth, gender, phone, email, address, city, state, postal_code, emergency_contact_name, emergency_contact_phone) VALUES
('Ahmed', 'Khan', '1985-04-12', 'Male', '03001234567', 'ahmed.khan@example.com', '123 Street, Lahore', 'Lahore', 'Punjab', '54000', 'Sara Khan', '03007654321'),
('Fatima', 'Ali', '1990-08-25', 'Female', '03007654321', 'fatima.ali@example.com', '456 Avenue, Karachi', 'Karachi', 'Sindh', '74000', 'Ali Raza', '03001234567'),
('Hassan', 'Raza', '1978-12-05', 'Male', '03009876543', 'hassan.raza@example.com', '789 Road, Islamabad', 'Islamabad', 'ICT', '44000', 'Ayesha Raza', '03006543210');

INSERT INTO doctors (first_name, last_name, department_id, phone, email, hire_date, specialty) VALUES
('Dr. Asad', 'Malik', 1, '03111234567', 'asad.malik@example.com', '2010-06-15', 'Cardiologist'),
('Dr. Sana', 'Qureshi', 2, '03117654321', 'sana.qureshi@example.com', '2012-09-20', 'Neurologist'),
('Dr. Imran', 'Shah', 3, '03119876543', 'imran.shah@example.com', '2008-03-10', 'Emergency Medicine');

INSERT INTO staff (first_name, last_name, role, department_id, phone, email, hire_date) VALUES
('Nadia', 'Khan', 'Nurse', 1, '03211234567', 'nadia.khan@example.com', '2015-01-05'),
('Bilal', 'Ahmed', 'Technician', 2, '03217654321', 'bilal.ahmed@example.com', '2016-04-12'),
('Amina', 'Rashid', 'Receptionist', 3, '03219876543', 'amina.rashid@example.com', '2014-07-22');

INSERT INTO rooms (room_number, department_id, room_type, capacity, status) VALUES
('101', 1, 'ICU', 1, 'available'),
('102', 2, 'General', 2, 'occupied'),
('103', 3, 'Operation Theater', 1, 'available');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason, status) VALUES
(1, 1, '2024-06-01 10:00:00', 'Chest pain', 'scheduled'),
(2, 2, '2024-06-02 11:30:00', 'Headache', 'completed'),
(3, 3, '2024-06-03 09:00:00', 'Accident injury', 'scheduled');

INSERT INTO treatments (appointment_id, treatment_description, treatment_date, notes) VALUES
(1, 'ECG and medication', '2024-06-01 10:30:00', 'Patient responded well'),
(2, 'MRI scan and medication', '2024-06-02 12:00:00', 'No abnormalities found'),
(3, 'Surgery and post-op care', '2024-06-03 09:30:00', 'Surgery successful');

INSERT INTO medications (treatment_id, medication_name, dosage, frequency, start_date, end_date) VALUES
(1, 'Aspirin', '75mg', 'Once daily', '2024-06-01', '2024-06-10'),
(2, 'Paracetamol', '500mg', 'Twice daily', '2024-06-02', '2024-06-07'),
(3, 'Antibiotics', '250mg', 'Thrice daily', '2024-06-03', '2024-06-13');

INSERT INTO billing (patient_id, appointment_id, amount, billing_date, payment_method, payment_status) VALUES
(1, 1, 5000.00, '2024-06-01', 'card', 'paid'),
(2, 2, 3000.00, '2024-06-02', 'cash', 'paid'),
(3, 3, 15000.00, '2024-06-03', 'insurance', 'pending');

INSERT INTO doctor_feedback (doctor_id, patient_id, rating, comments, feedback_date) VALUES
(1, 1, 5, 'Excellent care and attention.', '2024-06-05'),
(2, 2, 4, 'Very knowledgeable and helpful.', '2024-06-06'),
(3, 3, 5, 'Saved my life, very grateful.', '2024-06-07');

-- Additional constraints, triggers, and views can be added as needed for business logic
