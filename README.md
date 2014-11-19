Nexus 4 LTE and LTE hotspot/tethering fix
=========================================

Here is my Nexus 4 LTE and LTE hotspot/tethering fix. This is different from other fixes available in that, in addition, it should enable tethering/Wi-Fi portable hotspot over LTE for all service providers.


## What it does
* Flashes .33/1.04 hybrid radio
* Modifies settings.db to permanently enable LTE
* Adds init.d script that modifies iptables to fix LTE tethering upon bootup
* Adds addon.d script that maintains iptables modifications after ROM updates


## Requirements
Any **rooted 5.0 ROM with init.d support**, like CM, AOSPA, or modified stock and, of course, an LTE Band 4 AWS-enabled SIM and service provider.


## Installation instructions
1. Download the installer ZIP to your device, flash from recovery, and reboot.
2. After flashing, enable your correct LTE APN.


## Uninstallation instructions
Please see [uninstaller branch](https://github.com/marcandrews/Mako-LTE-and-LTE-hotspot-fix/tree/uninstaller) for more information.


## More about the LTE tethering fix
Since the Nexus 4 LTE hack was discovered, people on networks other then T-Mobile have been struggling to enable tethering over LTE. Pre-4.3, the solution was an iptables script to allow LTE tethering through the firewall. This solution no longer works for 4.3+. I have updated the script to allow LTE tethering through the firewall in 4.3+. My LTE fix applies the following changes:
```
iptables -D natctrl_FORWARD -j DROP
iptables -t nat -A natctrl_nat_POSTROUTING -o rmnet_usb0 -j MASQUERADE
```
The other issue is that this script had to be run each and every boot. Placing the commands within an init.d script does not work because at the time init.d scripts are run in the boot, the natctrl_nat_POSTROUTING rule does not exist, so you cannot append to it. Even if you do create the rule and append to it, the changes will be overwritten when the rules are set later in the boot. The solution is to run the commands within a delayed subshell that alters the firewall after the rules are set. This is what my LTE fix does:
```
(
  sleep 15
  iptables -D natctrl_FORWARD -j DROP
  iptables -t nat -A natctrl_nat_POSTROUTING -o rmnet_usb0 -j MASQUERADE
)
```


## More about the enabling LTE via settings.db
As I alluded to [back in July](http://forum.xda-developers.com/showpost.php?p=53825232&postcount=1315), the build.prop edits were never required to enabled LTE.
```
ro.telephony.default_network=9
ro.ril.def.preferred.network=9
```
These lines tell the phone which network mode to try after a factory reset. This is why some LTE-enabling methods asked you to factory reset to enabled LTE but who wants to factory reset just to enabled LTE. So if you're not resetting, these lines have no effect.
```
telephony.lteOnGsmDevice=1
```
This line was to allow the selection of LTE under Network Mode, but this menu is no longer available >4.3, so this line has no effect. It was only indirectly required because that selection menu allowed you to change the ```preferred_network_mode``` value in settings.db, and this is what enables LTE and allows it to stay enabled permanently following a reboot.

So if you can change the ```preferred_network_mode``` value directly, you do not need any build.prop edits, nor do you need the Network Mode selection menu. All you need is ```preferred_network_mode=9``` and an LTE-enabled modem/radio. This is what my LTE-enabler accomplishes.

As for the discussion about LTE sticking after ROM flashes settings.db is located on the data partition. ROM flashable zips rarely touch the data partition, and they also rarely flash a new modem, so as long as these two remain, and you have not wiped (because wiping clears the data partition, which in turn will clear the ```preferred_network_mode``` value), LTE will stick after a ROM flash. So basically, you only need to flash my LTE-enabler after wiping.


## Special thanks
* [XanSama](http://forum.xda-developers.com/showpost.php?p=36544976&postcount=20)
* #netfilter guys at freenode
* [morrislee](http://forum.xda-developers.com/showthread.php?p=43925317)
* [cg87](http://forum.xda-developers.com/showpost.php?p=48237939&postcount=882)
* partylikeaninjastar
* [beerbaronstatic](http://forum.xda-developers.com/showpost.php?p=56762318&postcount=1401)
* ramjet73
