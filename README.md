# Attribution Manager

This plugin provides developers with tools to store video game credits and manage
attributions for individual assets. It aims at making it easy to give correct attribution
to assets imported from third parties and keeping the attribution up to date.

On top of that, it aims to solve two problems:

1. An asset is checked in, but the person doing it forgets to add the correct attribution,
or any attribution at all. This leads to frantic searches and "where did I find this
again?"s towards the rear end of the development timeline. No one wants to be in that
situation at that time.
2. An asset is attributed wrongly and a complaint is lodged, maybe even with a DMCA
request attached, and there is a need to identify the person responsible. This might
sound overly corporate-y, but FOSS and CC licenses can only thrive if licensors have
the ability to enforce them.

Credits can be collected manually and automatically. They're stored in a single
resource that can be hooked up easily to any kind of credits scene. Credits for the
various roles in game development can be entered directly and with as many contributors
for each role as necessary. There is also a convenient resource type for crediting
entire asset stores.

![credits](docs/screenshot1.png)

Attributions for imported resources are entered in the inspector. There are pre-made
attribution types for the most common CC-style licenses found on the various asset
stores around the internet. The attributions are stored automatically in the credits
resource and update when attributions for an asset are changed or the asset is deleted.

![attribution](docs/screenshot2.png)

There is a special license type, `LicenseProject`, that you can use to handle attributions
for work done by members of the project and freelancers. These attributions are not stored
in the list of external attributions and the names of the contributors are automatically
added to the main credits array into the associated `Role` list.

> **Note:** When you remove an asset or an attribution from an asset, the project member
> is not automatically removed from the credits list. You will have to do that manually.
> Whether or not you *should* is up to you. When in doubt, refer to the 
> [IDGA Crediting Guide](https://igda.org/wp-content/uploads/2021/11/IGDA-Game-Crediting-Guidelines-10.1-March-2023.pdf)
> for some considerations on good business practices.
