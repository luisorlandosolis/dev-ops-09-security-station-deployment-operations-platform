# Architectural Decisions

## Decision 001

### Use Clonezilla Recovery as Platform Foundation

Decision:

The recovered production workstation image will serve as the foundation for future deployment efforts.

Rationale:

The recovered workstation represents a validated operational configuration and significantly reduces rebuild effort.

Status:

Approved

---

## Decision 002

### Use Golden Image Deployment Strategy

Decision:

Maintain a validated golden image as the deployment baseline.

Rationale:

A golden image ensures deployment consistency and reduces configuration drift between stations.

Status:

Approved

---

## Decision 003

### Use Hyper-V for Initial Validation

Decision:

Hyper-V will be used as the validation platform during early development.

Rationale:

Hyper-V provided rapid testing, recovery flexibility, snapshot capability, and low deployment effort.

Status:

Approved

---

## Decision 004

### Use Differencing Disks

Decision:

Use parent-child virtual disk architecture rather than full VM clones.

Rationale:

Differencing disks reduce storage requirements and simplify deployment management.

Status:

Approved

---

## Decision 005

### Standardize Around RDP Workflows

Decision:

Security stations will operate through an RDP-centric workflow whenever appropriate.

Rationale:

Centralized environments improve management, consistency, and operational flexibility.

Status:

Approved

---

## Decision 006

### Preserve Peripheral Compatibility

Decision:

All deployment architecture decisions must support required Security Station peripherals.

Validated Devices:

- Barcode Scanners
- Logitech Webcams
- DYMO LabelWriter Printers

Status:

Approved

---

## Decision 007

### Future Automation Through Ansible

Decision:

Station configuration will be managed through Ansible and Infrastructure as Code principles.

Rationale:

Automation improves consistency, reduces deployment effort, and supports repeatable workstation provisioning.

Status:

Approved

---

## Decision 008

### Migration to Proxmox

Decision:

Validated Hyper-V deployments will be migrated to Proxmox as the long-term virtualization platform.

Rationale:

Hyper-V successfully validated the deployment architecture, workstation workflows, and peripheral compatibility requirements.

Proxmox provides:

- Template Management
- Linked Clones
- Snapshot Management
- Proxmox Backup Server Integration
- Automation-Friendly Workflows
- Simplified Image Deployment
- Improved Scalability
- Future Infrastructure Flexibility

The migration strategy allows the validated Hyper-V architecture to transition into a platform better aligned with long-term deployment automation, observability, and lifecycle management goals.

Status:

Approved

---

## Decision 009

### Separate Hosted Security Environment from Security Station Endpoints

Decision:

Adopt a two-tier architecture consisting of a Hosted Security Environment and Security Station Endpoints.

Rationale:

Validation demonstrated that workstation functionality, peripherals, and business workflows could be delivered through a centralized architecture while maintaining operational requirements.

Benefits:

- Simplified workstation management
- Centralized application hosting
- Reduced endpoint complexity
- Improved recoverability
- Consistent user experience

Status:

Approved

---

## Decision 010

### Standardize on FQDN-Based Connectivity

Decision:

Security Station deployments will use Fully Qualified Domain Names (FQDNs) rather than short hostnames or static IP addresses whenever possible.

Rationale:

Validation demonstrated improved reliability and consistency when using DNS-based workstation targeting.

Benefits:

- Improved DNS reliability
- Reduced dependency on legacy name resolution
- Better Active Directory alignment
- Simplified workstation replacement
- Improved deployment consistency

Status:

Approved

---

---

## Decision 011

### Use Single Validation Target Strategy

Decision:

Security Station deployment and automation validation will be performed against a single validation workstation until identity management, hostname automation, and domain integration workflows are fully validated.

Validation Approach:

- Single validation target
- Controlled testing scope
- Incremental change management
- No production-wide modifications

Rationale:

Limiting validation to a single workstation reduces deployment risk while allowing automation, authentication, configuration management, and validation workflows to mature before wider adoption.

Status:

Approved

---

## Decision 012

### Enforce LocalAccountTokenFilterPolicy Baseline

Decision:

All Security Station templates, validation systems, deployment targets, and future workstation deployments must contain:

```text
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System

LocalAccountTokenFilterPolicy = 1
```

Rationale:

The setting is required for successful WinRM remote management using local administrative accounts.

Testing determined that its absence resulted in:

- NTLM authentication failures
- WinRM access failures
- Ansible connectivity failures

Status:

Approved

---

## Decision 013

### Require Unique Workstation Identity

Decision:

Security Station deployments must never inherit the identity of the parent image.

Requirements:

- Unique hostname
- Unique DNS registration
- Unique Active Directory computer object
- Unique workstation assignment

Deployment Workflow:

```text
Deploy Workstation
       ↓
Assign Hostname
       ↓
Remove Inherited Domain Identity
       ↓
Join Domain
       ↓
Register DNS
       ↓
Apply Configuration
```

Rationale:

Unique workstation identities are required to prevent DNS conflicts, Active Directory conflicts, monitoring inconsistencies, and configuration management issues.

Status:

Approved

---

## Decision 014

### Enforce Remote Desktop Trust-Warning Baseline

Decision:

All Security Station deployment targets must contain the following setting:

```text
HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client
```

Required Value:

```text
RedirectionWarningDialogVersion = 1
```

Rationale:

Validation determined that authentication and connectivity were functioning correctly, but a Remote Desktop trust-warning workflow prevented automated session establishment.

Benefits:

- Reduced technician interaction
- Improved deployment consistency
- Improved automation reliability
- Improved user experience

Status:

Approved

---

## Decision 015

### Treat Authentication and Trust as Separate Validation Domains

Decision:

Authentication validation and Remote Desktop trust validation will be treated as separate platform requirements.

Rationale:

Validation demonstrated that successful authentication does not guarantee a seamless Remote Desktop workflow.

Benefits:

- Faster root-cause analysis
- Improved deployment validation
- More reliable automation workflows
- Reduced troubleshooting effort

Status:

Approved

---

## Decision 016

Implement Security Station Validation Framework

Decision:

All deployments must support a standardized validation framework.

Validation Modules:

- LocalAccountTokenFilterPolicy
- WinRM Health
- AutoAdminLogon
- SecurityStation-RDP Task
- Printer Validation
- Camera Validation
- USB Validation
- Plug-and-Play Validation
- Service Validation
- Device Baseline Inventory

Rationale:

A standardized validation process improves deployment consistency, simplifies troubleshooting, and ensures workstation readiness before production use.

Status:

Approved

---
## Decision 017

### Implement Observability from Day One
Decision:

Future workstation deployments will include centralized monitoring.

Monitoring Platform:

- Grafana
- Prometheus
- Windows Exporter

Rationale:

Operational visibility improves troubleshooting, capacity planning, and platform health monitoring.

Status:

Approved

---

## Decision 018

### Treat Security Stations as Managed Appliances

Decision:

Security workstations should be deployed and managed as standardized operational appliances rather than traditional desktop systems.

Rationale:

Standardization improves security, recovery, supportability, and lifecycle management.

Status:

Approved
