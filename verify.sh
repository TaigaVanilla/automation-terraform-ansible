#!/bin/bash

set -e

echo "🔍 Project Verification Script"
echo "========================================"

# Get VM IPs from Terraform output
cd terraform
VM_IPS=$(terraform output -json | jq -r '.linux_vm_public_ips.value[]')
cd ..

echo "📋 Found VM IPs:"
echo "$VM_IPS"

# Test each VM
for ip in $VM_IPS; do
    echo ""
    echo "🔍 Testing VM: $ip"
    echo "----------------------------------------"
    
    # Test SSH connectivity
    echo "🔑 Testing SSH connectivity..."
    if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no azureuser@$ip "echo 'SSH connection successful'" 2>/dev/null; then
        echo "✅ SSH connection successful"
    else
        echo "❌ SSH connection failed"
        continue
    fi
    
    # Test web server
    echo "🌐 Testing web server..."
    if curl -s -o /dev/null -w "%{http_code}" http://$ip | grep -q "200"; then
        echo "✅ Web server responding (HTTP 200)"
    else
        echo "❌ Web server not responding"
    fi
    
    # Test profile configuration
    echo "📝 Testing profile configuration..."
    if ssh -o StrictHostKeyChecking=no azureuser@$ip "grep -q 'TMOUT=1500' /etc/profile"; then
        echo "✅ Profile timeout configured"
    else
        echo "❌ Profile timeout not configured"
    fi
    
    # Test user creation
    echo "👥 Testing user creation..."
    if ssh -o StrictHostKeyChecking=no azureuser@$ip "id user100 && id user200 && id user300"; then
        echo "✅ Users created successfully"
    else
        echo "❌ Users not created"
    fi
    
    # Test disk partitions
    echo "💾 Testing disk partitions..."
    if ssh -o StrictHostKeyChecking=no azureuser@$ip "mount | grep -q '/part1' && mount | grep -q '/part2'"; then
        echo "✅ Disk partitions mounted"
    else
        echo "❌ Disk partitions not mounted"
    fi
    
    # Test Apache service
    echo "🖥️  Testing Apache service..."
    if ssh -o StrictHostKeyChecking=no azureuser@$ip "systemctl is-active --quiet httpd"; then
        echo "✅ Apache service running"
    else
        echo "❌ Apache service not running"
    fi
    
    # Test file permissions
    echo "📄 Testing file permissions..."
    if ssh -o StrictHostKeyChecking=no azureuser@$ip "stat -c '%a' /var/www/html/index.html | grep -q '444'"; then
        echo "✅ File permissions correct (0444)"
    else
        echo "❌ File permissions incorrect"
    fi
done

echo ""
echo "🎉 Verification completed!"
echo "========================================"
echo "Summary:"
echo "- All VMs should be accessible via SSH"
echo "- Web servers should be responding on port 80"
echo "- Profile should have TMOUT=1500 configured"
echo "- Users user100, user200, user300 should exist"
echo "- Disk partitions should be mounted at /part1 and /part2"
echo "- Apache should be running and serving content"
echo "- Index.html should have 0444 permissions" 