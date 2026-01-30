# Main Analysis Workflow Documentation

## Overview

The `main-analysis` workflow runs on pushes to the main branch, providing comprehensive analysis of the entire codebase to ensure production readiness, track quality trends, and maintain high standards for the released code.

## Purpose

- **Production Readiness**: Ensure main branch is always releasable
- **Comprehensive Analysis**: Complete codebase analysis without scope limitations
- **Trend Tracking**: Monitor quality metrics over time
- **Release Preparation**: Generate artifacts and documentation for releases
- **Quality Assurance**: Maintain high standards for production code

## Trigger Configuration

```yaml
on:
  push:
    branches: [ main ]
  workflow_dispatch:
    inputs:
      full_analysis:
        description: 'Run full comprehensive analysis'
        required: false
        default: 'true'
        type: boolean
```

**Trigger Events:**
- `push`: Any push to main branch - automatic analysis
- `workflow_dispatch`: Manual trigger for on-demand analysis

## Workflow Architecture

```mermaid
flowchart TD
    A[Push to Main] --> B[full-build Job]
    B --> C[comprehensive-analysis Job]
    B --> D[security-scan Job]
    C --> E[quality-report Job]
    D --> E
    E --> F[release-prep Job]
    E --> G[trend-analysis Job]
    
    B --> H[Build Artifacts]
    C --> I[Analysis Reports]
    D --> J[Security Reports]
    E --> K[Quality Dashboard]
    
    style A fill:#e1f5fe
    style K fill:#e8f5e8
```

## Job Dependencies

```mermaid
graph TD
    A[full-build] --> B[comprehensive-analysis]
    A --> C[security-scan]
    B --> D[quality-report]
    C --> D
    D --> E[release-prep]
    D --> F[trend-analysis]
    
    style A fill:#e3f2fd
    style B fill:#f3e5f5
    style C fill:#ff9800
    style D fill:#fff3e0
    style E fill:#e8f5e8
    style F fill:#4caf50
```

**Execution Strategy:**
- **Parallel Analysis**: Comprehensive and security scans run in parallel
- **Central Coordination**: Quality report consolidates all results
- **Multiple Outputs**: Release preparation and trend analysis

## Jobs Detailed

### 1. Full Build Job

**Purpose**: Complete build and comprehensive testing of entire codebase

```mermaid
flowchart TD
    A[Checkout Full History] --> B[Setup Swift Environment]
    B --> C[Clean Build Environment]
    C --> D[Build All Targets]
    D --> E[Run Full Test Suite]
    E --> F[Generate Comprehensive Coverage]
    F --> G[Create Build Artifacts]
    G --> H[Upload Complete Artifacts]
    
    style A fill:#e3f2fd
    style H fill:#e8f5e8
```

**Key Differences from PR Build:**
- **Complete History**: Full git checkout for comprehensive analysis
- **All Targets**: Build all possible configurations and targets
- **Extended Testing**: Run all test suites including integration tests
- **Full Coverage**: Generate coverage for entire codebase

### 2. Comprehensive Analysis Job

**Purpose**: In-depth analysis of entire codebase quality

```mermaid
flowchart TD
    A[Download Build Artifacts] --> B[Extended SwiftLint Analysis]
    B --> C[Comprehensive Periphery Scan]
    C --> D[Code Complexity Analysis]
    D --> E[Documentation Coverage]
    E --> F[Upload Analysis Reports]
    
    style A fill:#e3f2fd
    style F fill:#e8f5e8
```

**Extended Analysis Tools:**
- Enhanced SwiftLint with production rules
- Complete Periphery scan without skip-build
- Code complexity metrics
- Documentation coverage analysis

### 3. Security Scan Job

**Purpose**: Comprehensive security analysis of entire codebase

```mermaid
flowchart TD
    A[Full Codebase Checkout] --> B[Advanced Gitleaks Scan]
    B --> C[Dependency Security Scan]
    C --> D[SAST Analysis]
    D --> E[Security Report Generation]
    
    style A fill:#e3f2fd
    style E fill:#e8f5e8
```

**Security Analysis Tools:**
- Enhanced Gitleaks with production rules
- Dependency vulnerability scanning
- Static Application Security Testing (SAST)
- License compliance checking

### 4. Quality Report Job

**Purpose**: Consolidate all analysis results into comprehensive quality report

```mermaid
flowchart TD
    A[Download All Reports] --> B[Consolidate Metrics]
    B --> C[Calculate Quality Score]
    C --> D[Generate Trend Analysis]
    D --> E[Create Executive Summary]
    E --> F[Update Quality Dashboard]
    
    style A fill:#e3f2fd
    style F fill:#e8f5e8
```

**Quality Metrics Consolidation:**

| Category | Metric | Current | Target | Trend |
|----------|--------|---------|--------|-------|
| **Coverage** | Regions | 99.28% | ≥ 98% | ↗️ |
| **Coverage** | Lines | 100.00% | ≥ 95% | → |
| **Code Quality** | Lint Violations | 0 | ≤ 5 | ↘️ |
| **Security** | Secrets | 0 | 0 | → |
| **Maintainability** | Dead Code | 0 | 0 | → |

### 5. Release Preparation Job

**Purpose**: Prepare artifacts and documentation for release

```mermaid
flowchart TD
    A[Quality Report Available] --> B[Generate Release Notes]
    B --> C[Create Release Artifacts]
    C --> D[Generate Documentation]
    D --> E[Create Change Log]
    E --> F[Upload Release Assets]
    
    style A fill:#e3f2fd
    style F fill:#e8f5e8
```

**Release Preparation Process:**
- Automated release notes generation
- Quality summary inclusion
- Artifact packaging with checksums
- Documentation updates

### 6. Trend Analysis Job

**Purpose**: Analyze quality trends and provide insights

```mermaid
flowchart TD
    A[Historical Data Collection] --> B[Trend Calculation]
    B --> C[Pattern Analysis]
    C --> D[Predictive Analytics]
    D --> E[Generate Insights]
    E --> F[Update Trend Dashboard]
    
    style A fill:#e3f2fd
    style F fill:#4caf50
```

**Trend Analysis Features:**
- Quality trend tracking
- Anomaly detection
- Predictive analytics
- Improvement recommendations

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `FULL_ANALYSIS` | true | Enable comprehensive analysis |
| `TREND_ANALYSIS` | true | Enable trend analysis |
| `RELEASE_PREP` | true | Enable release preparation |
| `SECURITY_SCAN` | true | Enable comprehensive security scan |
| `QUALITY_THRESHOLD` | 98 | Higher threshold for main branch |

### Repository Configuration

**Required Files:**
- `.github/workflows/main-analysis.yml`
- `.swiftlint-production.yml` - Production lint rules
- `.gitleaks-production.toml` - Production security rules
- `quality-trends.json` - Historical trend data

## Performance Metrics

### Execution Time

| Job | Average Time | Optimization |
|------|---------------|-------------|
| full-build | 10-15 minutes | Parallel builds |
| comprehensive-analysis | 8-12 minutes | Efficient scanning |
| security-scan | 5-8 minutes | Optimized rules |
| quality-report | 3-5 minutes | Template reuse |
| release-prep | 2-4 minutes | Automation |
| trend-analysis | 2-3 minutes | Efficient algorithms |
| **Total** | **30-47 minutes** | **Overall optimization** |

### Resource Requirements

**Runner Specifications:**
- **Type**: `macos-26`
- **Memory**: 16GB recommended
- **Storage**: 20GB for comprehensive artifacts
- **Timeout**: 60 minutes for full workflow

## Quality Standards

### Main Branch Requirements

| Metric | Requirement | Current | Status |
|--------|-------------|---------|--------|
| Coverage | ≥ 98% | 99.28% | ✓ |
| Security Issues | 0 | 0 | ✓ |
| Code Quality | ≤ 5 violations | 0 | ✓ |
| Dead Code | 0 | 0 | ✓ |
| Documentation | ≥ 80% | 85% | ✓ |

## Integration Points

### External Services

```mermaid
graph LR
    A[Main Analysis] --> B[SonarCloud]
    A --> C[Quality Dashboard]
    A --> D[Release Management]
    A --> E[Trend Analytics]
    
    B --> F[Quality Metrics]
    C --> G[Visualization]
    D --> H[Release Pipeline]
    E --> I[Insights]
    
    style A fill:#2196f3
    style B fill:#4caf50
    style C fill:#ff9800
    style D fill:#9c27b0
    style E fill:#f44336
```

### Data Flow

```mermaid
sequenceDiagram
    participant M as Main Branch
    participant FB as full-build
    participant CA as comprehensive-analysis
    participant SS as security-scan
    participant QR as quality-report
    participant RP as release-prep
    participant TA as trend-analysis
    
    M->>FB: Push to main
    FB->>FB: Complete build & test
    FB->>CA: Build artifacts
    FB->>SS: Build artifacts
    FB->>QR: Build artifacts
    
    CA->>QR: Analysis reports
    SS->>QR: Security reports
    QR->>RP: Quality report
    QR->>TA: Trend data
    
    RP->>M: Release assets
    TA->>M: Trend insights
```

## Error Handling

### Comprehensive Error Handling

**Build Failures:**
- Complete build environment cleanup
- Detailed error reporting
- Automatic retry mechanisms
- Rollback procedures

**Analysis Failures:**
- Graceful degradation
- Partial analysis completion
- Error isolation
- Recovery strategies

**Release Failures:**
- Validation checks
- Rollback capabilities
- Notification systems
- Manual override options

## Best Practices

### Production Readiness

1. **Higher Standards**: Stricter quality thresholds for main branch
2. **Comprehensive Testing**: Full test suite execution
3. **Complete Analysis**: No scope limitations
4. **Trend Monitoring**: Continuous quality tracking

### Release Management

1. **Automated Preparation**: Streamlined release process
2. **Quality Validation**: Pre-release quality checks
3. **Documentation**: Comprehensive release notes
4. **Artifact Management**: Proper versioning and storage

### Trend Analysis

1. **Historical Tracking**: Long-term quality trends
2. **Pattern Recognition**: Identify quality patterns
3. **Predictive Analytics**: Future quality predictions
4. **Continuous Improvement**: Data-driven decisions

## Future Enhancements

### Planned Improvements

1. **Advanced Analytics**: Machine learning for quality prediction
2. **Automated Releases**: Fully automated release pipeline
3. **Performance Monitoring**: Real-time performance tracking
4. **Integration Expansion**: More external service integrations

### Scaling Considerations

- **Large Codebases**: Optimized analysis for large projects
- **Multiple Environments**: Staging, production workflows
- **Cross-Platform**: Multi-platform build support
- **Distributed Builds**: Parallel build infrastructure

## Related Documentation

- [Pull Request Analysis Workflow](pull-request-analysis.md)
- [Pre-commit Autoupdate Workflow](pre-commit-autoupdate.md)
- [Main README](README.md)
