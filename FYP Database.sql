CREATE DATABASE WonderVisionCMS;
USE WonderVisionCMS;

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL COMMENT 'Use bcrypt or Argon2 for secure hashing',
    Role ENUM('Admin', 'Viewer', 'Operator') NOT NULL,
    Status Enum('Active', 'Inactive'),
    ProfileImage VARCHAR(500) NULL COMMENT 'Stores the URL or path of the user profile image',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Cameras (
    CameraID INT AUTO_INCREMENT PRIMARY KEY,
    CameraName VARCHAR(100) NOT NULL,
    CameraType ENUM('RTSP', 'IP', 'CCTV') NOT NULL,
    CameraURL VARCHAR(500) NOT NULL,
    CameraLocation VARCHAR(255),
    Status ENUM('Online', 'Offline') DEFAULT 'Offline',
    LastActive DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE UserPermissions (
    PermissionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    CameraID INT NOT NULL,
    PermissionType ENUM('View', 'Manage') NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CameraID) REFERENCES Cameras(CameraID) ON DELETE CASCADE
);

CREATE TABLE FaceRecognition (
    RecognitionID INT AUTO_INCREMENT PRIMARY KEY,
    CameraID INT NOT NULL,
    DetectedPerson VARCHAR(255),
    Location VARCHAR(255),
    DetectedImage VARCHAR(500) COMMENT 'Path or URL of detected face snapshot',
    Alert ENUM('Alert Sent', 'No Alert'),
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CameraID) REFERENCES Cameras(CameraID) ON DELETE CASCADE
);

CREATE TABLE PeopleDetection (
    DetectionID INT AUTO_INCREMENT PRIMARY KEY,
    CameraID INT NOT NULL,
    PeopleCount INT NOT NULL,
    DetectionTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CameraID) REFERENCES Cameras(CameraID) ON DELETE CASCADE
);

CREATE TABLE AttributesRecognition (
    AttributeID INT AUTO_INCREMENT PRIMARY KEY,
    CameraID INT NOT NULL,
    AttributeType VARCHAR(100),  
    AttributeValue VARCHAR(100),
    DetectionTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CameraID) REFERENCES Cameras(CameraID) ON DELETE CASCADE
);

CREATE TABLE AnomalyDetection (
    AnomalyID INT AUTO_INCREMENT PRIMARY KEY,
    CameraID INT NOT NULL,
    AnomalyType VARCHAR(255),
    Region VARCHAR(255),
    AlertSent ENUM('Yes', 'No'),
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CameraID) REFERENCES Cameras(CameraID) ON DELETE CASCADE
);

CREATE TABLE Alerts (
    AlertID INT AUTO_INCREMENT PRIMARY KEY,
    CameraID INT NOT NULL,
    AlertTitle TEXT,
    CreatedBy ENUM('Admin', 'User'),
	AlertStatus ENUM('Active', 'Inactive'),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CameraID) REFERENCES Cameras(CameraID) ON DELETE CASCADE
);

CREATE TABLE Reports (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    ReportTitle VARCHAR(255) NOT NULL,
    DateGenerated DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE SystemSettings (
    SettingID INT AUTO_INCREMENT PRIMARY KEY,
    SettingName VARCHAR(100) UNIQUE NOT NULL,
    SettingValue VARCHAR(255) NOT NULL
);

CREATE TABLE FaceRecognitionSettings (
    SettingID INT AUTO_INCREMENT PRIMARY KEY,
    CameraID INT NOT NULL,
    Enabled BOOLEAN DEFAULT TRUE,
    AlertOnUnrecognizedFace BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (CameraID) REFERENCES Cameras(CameraID) ON DELETE CASCADE
);

CREATE TABLE PeopleDetectionSettings (
    SettingID INT AUTO_INCREMENT PRIMARY KEY,
	CameraID INT NOT NULL,
    Enabled BOOLEAN DEFAULT TRUE,
    MaxPeopleAllowed INT DEFAULT 10,
    AlertIfLimitExceeded BOOLEAN DEFAULT TRUE
);

CREATE TABLE AttributeRecognitionSettings (
    SettingID INT AUTO_INCREMENT PRIMARY KEY,
	CameraID INT NOT NULL,
    Enabled BOOLEAN DEFAULT TRUE,
    DetectableAttributes VARCHAR(255),
    AlertOnSuspiciousObjects BOOLEAN DEFAULT TRUE
);

CREATE TABLE AnomalyDetectionSettings (
    SettingID INT AUTO_INCREMENT PRIMARY KEY,
    Enabled BOOLEAN DEFAULT TRUE,
    MonitoredAreas VARCHAR(255),
    AlertOnUnauthorizedMovement BOOLEAN DEFAULT TRUE
);
