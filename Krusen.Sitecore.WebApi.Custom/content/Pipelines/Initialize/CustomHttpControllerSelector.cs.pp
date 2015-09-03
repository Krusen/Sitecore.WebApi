using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Dispatcher;
using System.Web.Http.Routing;
using Sitecore.Services.Core;

namespace $rootNamespace$.Pipelines.Initialize
{
    public class CustomHttpControllerSelector : DefaultHttpControllerSelector
    {
        private const string NamespaceKey = "namespace";
        private const string ControllerKey = "controller";
        private readonly HttpConfiguration _configuration;
        private readonly IControllerNameGenerator _controllerNameGenerator;
        private readonly Dictionary<string, HttpControllerDescriptor> _controllers;

        public CustomHttpControllerSelector(HttpConfiguration config, IControllerNameGenerator controllerNameGenerator)
            : base(config)
        {
            _configuration = config;
            _controllerNameGenerator = controllerNameGenerator;
            _controllers = InitializeControllerDictionary();
        }

        private Dictionary<string, HttpControllerDescriptor> InitializeControllerDictionary()
        {
            var dictionary = new Dictionary<string, HttpControllerDescriptor>(StringComparer.OrdinalIgnoreCase);
            var assembliesResolver = _configuration.Services.GetAssembliesResolver();
            var httpControllerTypeResolver = _configuration.Services.GetHttpControllerTypeResolver();
            var controllerTypes = httpControllerTypeResolver.GetControllerTypes(assembliesResolver);
            foreach (var current in controllerTypes)
            {
                var name = _controllerNameGenerator.GetName(current);
                if (!dictionary.Keys.Contains(name))
                {
                    dictionary[name] = new HttpControllerDescriptor(_configuration, current.Name, current);
                }
            }
            return dictionary;
        }

        public override HttpControllerDescriptor SelectController(HttpRequestMessage request)
        {
            var routeData = request.GetRouteData();
            var namespaceVariable = GetRouteVariable<string>(routeData, NamespaceKey);
            var controllerVariable = GetRouteVariable<string>(routeData, ControllerKey);

            // Use default logic if no controller variable exist
            if (string.IsNullOrEmpty(controllerVariable))
                return base.SelectController(request);

            var httpControllerDescriptor = FindMatchingController(namespaceVariable,
                controllerVariable);
            if (httpControllerDescriptor != null)
            {
                return httpControllerDescriptor;
            }

            throw new HttpResponseException(HttpStatusCode.NotFound);
        }

        private static T GetRouteVariable<T>(IHttpRouteData routeData, string name)
        {
            object obj;
            if (routeData.Values.TryGetValue(name, out obj))
            {
                return (T)obj;
            }
            return default(T);
        }

        private HttpControllerDescriptor FindMatchingController(string namespaceName, string controllerName)
        {
            var key = string.IsNullOrEmpty(namespaceName)
                ? controllerName
                : string.Format(CultureInfo.InvariantCulture, "{0}.{1}", namespaceName, controllerName);
            HttpControllerDescriptor result;
            return _controllers.TryGetValue(key, out result) ? result : null;
        }
    }
}