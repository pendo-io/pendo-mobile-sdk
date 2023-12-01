# MAUI migration from version 2.x to version 3.x

The following changes are required:

<table border=2>
<tr>
<td align=center><b>Component / API </td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>.NET</td>
<td>

<b>2.x (deprecated):</b> `.NET 6`
<br>
<b>3.x:</b> `.NET 7`

</td>
</tr>



<!--- new row --->

<tr>
<td align=center><b>Minimum <br> Kotlin version</b> <br> <i> (Relevant for Android apps only) </td>
<td>

<b>2.x (deprecated):</b> `1.7.20`
<br>
<b>3.x:</b> `1.9.0`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Target <br> Android version</b> <br> <i> (Relevant for Android apps only) </td>
<td>

<b>2.x (deprecated):</b> `API Level 31 (v12.0)`
<br>
<b>3.x:</b> `API Level 33 (v13.0)`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Obtain  the <br> Pendo instance</b></td>

<td>

Obtain the shared project `Pendo` instance using the `PendoServerFactory` instead of creating a new `PendoInterface` instance.

<b>2.x (deprecated):</b>

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