# MAUI Migration From 2.x to 3.x

The following changes are required:

<table border=2>
<tr>
<td align=center><b>Component / API </td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Obtaining the Pendo Instance</b></td>

<td>

Fetch the `Pendo` instance using the the `PendoServerFactory` instead of creating a new `PendoInterface` instance.

<b>2.x:</b>

```C#
PendoInterface Pendo = new PendoInterface();
```

<b>3.x:</b>

```C#
IPendoService Pendo = PendoServiceFactory.CreatePendoService();
```

</td>
</tr>
</table>