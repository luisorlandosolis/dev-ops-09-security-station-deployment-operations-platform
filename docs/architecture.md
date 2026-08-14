# Architecture

## Overview

The Security Station Deployment & Recovery Platform is a proof of concept focused on modernizing Security Station deployment, recovery, validation, and operational management through standardization, automation, and virtualization.

The objective is to align with existing operational workflows while improving deployment consistency, recoverability, supportability, and long-term sustainability.

---

## Architecture Principles

The platform is based on the following principles:

- Standardized deployment workflows
- Consistent workstation configuration
- Validated deployment baselines
- Unique workstation identity management
- Automated configuration management
- Simplified recovery operations
- Future observability and lifecycle management

---

## Platform Components

### Hosted Security Environment Layer

Provides centralized hosting of Security Station workloads and operational services.

Responsibilities:

- Security application hosting
- Centralized workstation management
- Peripheral integration
- Remote Desktop access
- Operational standardization

Benefits:

- Reduced workstation complexity
- Simplified support
- Centralized application management
- Improved recoverability
- Consistent operator experience

### Security Station Endpoint Layer

Provides technician and operator access to the Hosted Security Environment.

Responsibilities:

- User access
- Remote Desktop connectivity
- Session initiation
- Device redirection
- Local workstation management

Validated Peripherals:

- Barcode scanners
- Webcam devices
- DYMO LabelWriter printers

Validation Status:

- Scanner Validation: PASS
- Webcam Validation: PASS
- DYMO Validation: PASS

---

## Mandatory Windows Baseline

The following settings are required for all Security Station templates, parent images, validation systems, and deployed workstations.

### Remote Desktop Standards

The platform standardizes on Remote Desktop as the primary workstation-access method.

Requirements:

- FQDN-based targeting
- Device redirection support
- Printer redirection support
- Webcam redirection support
- Consistent workstation connectivity

Validated Components:

- Remote Desktop connectivity
- Device redirection
- Webcam redirection
- Printer redirection
- SecurityStation-RDP scheduled task

Mandatory Baseline:

```text
HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client
```

Required Value:

```text
RedirectionWarningDialogVersion = 1
```

Purpose:

Supports automated workstation connection workflows and reduces technician interaction requirements.

### WinRM & Automation Standards

Registry Path:

```text
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
```

Value:

```text
LocalAccountTokenFilterPolicy = 1
```

Purpose:

Provides reliable WinRM authentication and supports Ansible-based workstation management.

---

### Technician Operations Layer

Provides a technician-friendly deployment workflow through a deployment console and guided deployment process.

Components:

- Deployment GUI
- Station Selection
- Validation Reporting
- Deployment Status

---

### Deployment Automation Layer

Provides automated configuration and deployment capabilities.

Components:

- PowerShell Deployment Framework
- Ansible
- Inventory Management
- Future Vault Integration

Functions:

- Workstation Configuration
- Baseline Enforcement
- Deployment Validation
- Authentication Management

---

### Identity Management Layer

Ensures all Security Stations maintain unique identities.

Requirements:

- Unique Hostname
- Unique DNS Registration
- Unique Active Directory Computer Object
- Unique Workstation Identity

Security Station deployments must not inherit workstation identity information from the parent image.

---

### Validation Framework Layer

Provides automated verification of Security Station readiness.

Validation Modules:

- LocalAccountTokenFilterPolicy
- WinRM Health
- AutoAdminLogon
- SecurityStation-RDP
- Printer Validation
- Camera Validation
- USB Validation
- Plug-and-Play Validation
- Service Validation
- Device Baseline Inventory

---

### Observability Layer

Provides operational visibility and proactive monitoring.

Components:

- Windows Exporter
- Prometheus
- Grafana

Objectives:

- Establish workstation baselines
- Monitor platform health
- Support proactive operations
- Improve troubleshooting visibility

---

## Mandatory Windows Baseline

The following setting is required for all Security Station templates, parent images, validation systems, and deployed workstations.

Registry Path:

```text
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
```

Value:

```text
LocalAccountTokenFilterPolicy = 1
```

Purpose:

Provides reliable WinRM authentication and supports Ansible-based workstation management.

---

## Hypervisor Standards

### Golden Image Strategy

The platform utilizes a validated parent-image deployment model.

Components:

- Golden Image
- Preserved Recovery Image
- Differencing Disks
- Security Station Deployments

Benefits:

- Consistent workstation baselines
- Rapid deployment
- Simplified recovery
- Image preservation

---

### Hyper-V Deployment Standard

Automatic checkpoints are disabled for Security Station deployments.

Purpose:

- Prevent unnecessary checkpoint chains
- Reduce differencing-disk complexity
- Simplify recovery operations
- Improve deployment consistency

Validation:

```powershell
Get-VM <VMName> | Select Name, AutomaticCheckpointsEnabled
```

Expected:

```text
False
```

---

## Deployment Workflow

```text
Golden Image
      ↓
Deploy Security Station
      ↓
Assign Identity
      ↓
Configure Workstation
      ↓
Validate Configuration
      ↓
Deploy to Operations
```

---

## Future Platform Evolution

### Authentication Modernization

Future evaluation includes:

- Vault-managed credential retrieval
- Centralized credential management
- Reduced credential exposure
- Improved automation workflows

---

### High Availability & Disaster Recovery

Future evaluation includes:

- Secondary virtualization host
- Recovery asset replication
- Template replication
- Platform resiliency improvements

---

### Observability Expansion

Future evaluation includes:

- Proactive alerting
- Capacity planning
- Service health analysis
- Availability monitoring
- Platform trend analysis

---

## Target Outcome

The long-term objective is a standardized Security Station lifecycle platform capable of:

```text
Deploy
    ↓
Configure
    ↓
Validate
    ↓
Monitor
    ↓
Maintain
    ↓
Recover
```

while remaining aligned with existing operational workflows.

Expected benefits include:

- Estimated recovery time reduction
- Standardized deployments
- Reduced configuration drift
- Improved recoverability
- Extended hardware lifecycle
- Enhanced operational visibility
- Future-ready platform architecture
