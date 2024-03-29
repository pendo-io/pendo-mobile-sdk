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
<b>3.x:</b> `.NET 7` or `.NET 8` 

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

<!--- new row --->

<tr>
<td align=center><b>Register <br> Pendo Effects</b> </td>
<td>

<b>2.x (deprecated):</b> N/A
<br>
<b>3.x:</b> 
If your app is using Gestures, you must upgrade to SDK version 3.1 or above and then register <b>Pendo Effects</b> (PendoRoutingEffect, PendoPlatformEffect) in your <b>MauiProgram.cs</b> file as shown in the code below.

```C#
...
using PendoMAUIPlugin;
...

public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();
        builder.UseMauiApp<App>();

        builder.ConfigureEffects(effects =>
        {
            effects.Add<PendoRoutingEffect, PendoPlatformEffect>();
        });
        return builder.Build();
    }
}
```
</td>
</tr>
</table>