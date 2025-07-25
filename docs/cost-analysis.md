# Cost Analysis

## Monthly Cost Breakdown

### CPU Configuration (gpu_enabled=false)
| Component | Type | Monthly Cost |
|-----------|------|--------------|
| EC2 Instance | t3.small on-demand | ~$15-18 |
| EBS Storage | 60GB gp2 | ~$6 |
| Data Transfer | Minimal usage | ~$1 |
| **Total** | | **~$22-25/month** |

### GPU Configuration (gpu_enabled=true)
| Component | Type | Monthly Cost |
|-----------|------|--------------|
| EC2 Instance | g4dn.xlarge on-demand | ~$125-140 |
| EBS Storage | 60GB gp2 | ~$6 |
| Data Transfer | Minimal usage | ~$1 |
| **Total** | | **~$132-147/month** |

*Note: Costs vary by AWS region. Estimates based on us-west-1 pricing.*

## Cost Optimization Strategies

### Instance Right-Sizing
- **Development/Testing**: t3.small handles lightweight models efficiently
- **Production/Heavy Models**: g4dn.xlarge provides GPU acceleration when needed
- **Conditional Deployment**: Single terraform variable controls cost vs performance trade-off

### Storage Optimization
- **EBS gp2**: Standard general-purpose SSD storage
- **Volume Size**: 60GB accommodates multiple AI models and container images
- **Future Enhancement**: Consider gp3 for better price/performance ratio

### Network Optimization
- **Single AZ Deployment**: Reduces cross-AZ data transfer costs
- **Public IP**: Direct internet access eliminates NAT Gateway costs (~$45/month savings)
- **Minimal Data Transfer**: Local model processing reduces external API costs

## Deployment Flexibility

### On-Demand Instances
- **Advantages**: Guaranteed availability, no interruption risk
- **Use Case**: Consistent workloads, development environments
- **Cost**: Predictable monthly billing

### Alternative Considerations
- **Spot Instances**: Could reduce costs by ~70% but adds complexity
- **Reserved Instances**: 1-year commitment offers ~30% savings
- **Scheduled Instances**: For predictable usage patterns

## Cost Comparison

### vs Managed AI Services
- **OpenAI GPT-4 API**: $0.03/1K input tokens, $0.06/1K output tokens
- **Heavy Usage Estimate**: $200-500/month for business applications
- **This Solution**: Fixed infrastructure cost regardless of token usage
- **Break-even**: Approximately 5,000-10,000 tokens daily

### vs Other Self-Hosted Options
- **Dedicated Bare Metal**: $200-800/month depending on specifications
- **Managed Container Services**: $100-300/month plus compute costs
- **This Solution**: Direct EC2 deployment with full control

## Regional Cost Variations

### US West (Oregon) - us-west-2
- **t3.small**: $0.0208/hour (~$15/month)
- **g4dn.xlarge**: $0.526/hour (~$380/month)

### US East (N. Virginia) - us-east-1
- **t3.small**: $0.0208/hour (~$15/month)
- **g4dn.xlarge**: $0.526/hour (~$380/month)

*Use AWS Pricing Calculator for exact regional pricing*

## Cost Monitoring Recommendations

### AWS Cost Explorer
- Track monthly spending trends
- Monitor service-level costs
- Set up cost alerts for budget overruns

### Resource Tagging
- Tag instances with project/environment labels
- Enable cost allocation for detailed reporting
- Track costs across different deployments

### Optimization Opportunities
- **Right-sizing**: Monitor CPU/memory utilization
- **Scheduling**: Stop instances during non-business hours
- **Reserved Capacity**: For consistent long-term usage