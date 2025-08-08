#!/bin/bash

# Script to register custom Fabric components in the generated provider files

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."

# Define the paths to the provider files
PROVIDER_FILES=(
    "$PROJECT_ROOT/build/generated/ios/RCTThirdPartyComponentsProvider.mm"
    "$PROJECT_ROOT/ios/build/generated/ios/RCTThirdPartyComponentsProvider.mm"
)

# Component registration code
IMPORT_LINE="#import \"../../../DocumentVerification/DocumentVerificationView.h\""
COMPONENT_ENTRY="    @\"DocumentVerificationView\": DocumentVerificationView.class"

for provider_file in "${PROVIDER_FILES[@]}"; do
    if [[ -f "$provider_file" ]]; then
        echo "Registering component in $provider_file"
        
        # Check if our import is already there
        if ! grep -q "$IMPORT_LINE" "$provider_file"; then
            # Add import after the existing imports
            sed -i '' "/^#import <React\/RCTComponentViewProtocol.h>/a\\
\\
// Import our custom component\\
$IMPORT_LINE
" "$provider_file"
        fi
        
        # Check if our component registration is already there
        if ! grep -q "DocumentVerificationView.*class" "$provider_file"; then
            # Replace the empty return statement with our component
            sed -i '' "s/return @{.*};/return @{\\
$COMPONENT_ENTRY\\
  };/" "$provider_file"
        fi
        
        echo "Successfully registered DocumentVerificationView in $provider_file"
    else
        echo "Provider file not found: $provider_file"
    fi
done

echo "Component registration complete!"