# Krusen.Sitecore.WebApi [![NuGet](https://img.shields.io/nuget/v/Krusen.Sitecore.WebApi.svg)](https://www.nuget.org/packages/Krusen.Sitecore.WebApi/) [![NuGet](https://img.shields.io/nuget/dt/Krusen.Sitecore.WebApi.svg)](https://www.nuget.org/packages/Krusen.Sitecore.WebApi/)

Use this nuget package if you just want Web API 2 and Attribute Routing to work with your Sitecore 7.5 or Sitecore 8 solution.

It comes with a compiled assembly that takes care of mapping the routes and is patched into the `initialize` pipeline.

```
<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/">
  <sitecore>
    <pipelines>
      <initialize>
        <processor type="Krusen.Sitecore.WebApi.ConfigureAttributeRouting, Krusen.Sitecore.WebApi"
                   patch:after="processor[@type='Sitecore.Services.Infrastructure.Sitecore.Pipelines.ServicesWebApiInitializer, Sitecore.Services.Infrastructure.Sitecore']" />
      </initialize>
    </pipelines>
  </sitecore>
</configuration>
```

# Krusen.Sitecore.WebApi.Custom [![NuGet](https://img.shields.io/nuget/v/Krusen.Sitecore.WebApi.Custom.svg)](https://www.nuget.org/packages/Krusen.Sitecore.WebApi.Custom/) [![NuGet](https://img.shields.io/nuget/dt/Krusen.Sitecore.WebApi.Custom.svg)](https://www.nuget.org/packages/Krusen.Sitecore.WebApi.Custom/)

Use this nuget package if you have special needs or just want to have complete control of the code in your project.

The code needed is added to your project and will be patched into the `initialize` pipeline as with the other package.

Your project will need to reference `Sitecore.Kernel` and `Sitecore.Services.Core` to be able to build.
