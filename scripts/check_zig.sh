CHECK_VERSION="0.12"

# Fetch upstream info
res=$(curl -s https://ziglang.org/download/index.json)

# Get version info
upstream_version_string=$(echo "$res" | jq -r .master.version)
upstream_version=$(echo "${upstream_version_string}" | cut -d'.' -f1,2)
upstream_build="$(echo "${upstream_version_string}" | cut -d'.' -f3,4 | sed 's/-dev//')"

# Check if version got bumped
if [[ "$upstream_version" != "$CHECK_VERSION" ]]; then
    echo "Error: The nightly version got bumped. Please create a new @$upstream_version package"
    exit 1
fi

# Read package version
package_path="./Formula/z/zig@$CHECK_VERSION.rb"
package_version=$(sed -n 's/^[[:space:]]*version "\(.*\)".*/\1/p' "$package_path")

# Check for update
if [[ "$upstream_build" == "$package_version" ]]; then
    echo "No update available, exiting"
    exit 1
fi

# Get shasum
upstream_sha_mac_arm=$(echo "$res" | jq -r ".master.\"aarch64-macos\".shasum")
upstream_sha_mac_x64=$(echo "$res" | jq -r ".master.\"x86_64-macos\".shasum")
upstream_sha_linux_arm=$(echo "$res" | jq -r ".master.\"aarch64-linux\".shasum")
upstream_sha_linux_x64=$(echo "$res" | jq -r ".master.\"x86_64-linux\".shasum")

package_sha_all=$(sed -n 's/^[[:space:]]*sha256 "\(.*\)".*/\1/p' "$package_path" | tr '\n' ',')
package_sha_mac_arm=$(echo "${package_sha_all}" | cut -d',' -f1)
package_sha_mac_x64=$(echo "${package_sha_all}" | cut -d',' -f2)
package_sha_linux_arm=$(echo "${package_sha_all}" | cut -d',' -f3)
package_sha_linux_x64=$(echo "${package_sha_all}" | cut -d',' -f4)

# Update file content
sed "s/$package_version/$upstream_build/g" "$package_path" > "$package_path.tmp" && mv "$package_path.tmp" "$package_path"
sed "s/$package_sha_mac_arm/$upstream_sha_mac_arm/g" "$package_path" > "$package_path.tmp" && mv "$package_path.tmp" "$package_path"
sed "s/$package_sha_mac_x64/$upstream_sha_mac_x64/g" "$package_path" > "$package_path.tmp" && mv "$package_path.tmp" "$package_path"
sed "s/$package_sha_linux_arm/$upstream_sha_linux_arm/g" "$package_path" > "$package_path.tmp" && mv "$package_path.tmp" "$package_path"
sed "s/$package_sha_linux_x64/$upstream_sha_linux_x64/g" "$package_path" > "$package_path.tmp" && mv "$package_path.tmp" "$package_path"

git add "$package_path"
git commit -m "[Autoupdate]: sync zig@$CHECK_VERSION"  > /dev/null

echo "The zig@$CHECK_VERSION package has been upgraded to $upstream_build, please push to confirm"
