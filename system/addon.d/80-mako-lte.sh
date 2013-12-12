#!/sbin/sh
# Nexus 4 LTE and LTE hotspot/tethering fix

. /tmp/backuptool.functions

case "$1" in
  restore)
    grep -Ev 'telephony.lteOnGsmDevice|ro.telephony.default_network|ro.ril.def.preferred.network' /system/build.prop > /tmp/build.prop
    echo 'telephony.lteOnGsmDevice=1' >> /tmp/build.prop
    echo 'ro.telephony.default_network=10' >> /tmp/build.prop
    echo 'ro.ril.def.preferred.network=10' >> /tmp/build.prop
    mv /tmp/build.prop /system/build.prop
    chmod 644 /system/build.prop
    
    # sqlite3 "/data/data/com.android.providers.settings/databases/settings.db" "INSERT INTO global (name, value) VALUES ('tether_dun_required', 0)"

    echo '#!/system/bin/sh
# Nexus 4 LTE and LTE hotspot/tethering fix

(
  sleep 15
  iptables -D natctrl_FORWARD -j DROP
  iptables -t nat -A natctrl_nat_POSTROUTING -o rmnet_usb0 -j MASQUERADE
)
' > /system/etc/init.d/81makoltetether
    chmod 755 /system/etc/init.d/81makoltetether
  ;;

esac
