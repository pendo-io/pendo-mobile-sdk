# MAUI Migration From 2.x to 3.x

The following changes are required:

<table border=2>
<tr>
<td align=center><b>Component / API </td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> Kotlin Version</b> <br> <i> (Relevant for Android Apps only) </td>
<td>

<b>2.x:</b> 

<b>3.x:</b> `1.8.0`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Obtaining the <br> Pendo Instance</b></td>

<td>

Fetch the `Pendo` instance using the the `PendoServerFactory` instead of creating a new `PendoInterface` instance.

<b>2.x:</b>

```C#
PendoInterface pendo = new PendoInterface();
```

<b>3.x:</b>

```C#
IPendoService pendo = PendoServiceFactory.CreatePendoService();

// if your app supports additional Platforms other than iOS and Android, verify the Pendo instance is not null
if (pendo != null) { 

    // the rest of your Pendo code

}
```

</td>
</tr>
</table>