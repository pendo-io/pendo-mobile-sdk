# MAUI Migration From 2.x to 3.x

The following changes are required:

<table border=2>
<tr>
<td> </td>
<td><b> 2.x</b></td>
<td><b>3.x</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center>Obtaining the Pendo Instance</td>
<td>

```C#
PendoInterface Pendo = new PendoInterface();
```
</td>
<td>

Fetch the `Pendo` instance using the the `PendoServerFactory` as follows:

```C#
IPendoService Pendo = PendoServiceFactory.CreatePendoService();
```

</td>
</tr>
</table>