using System.Web.Http;
using System.Web.Http.Dispatcher;
using Sitecore.Pipelines;
using Sitecore.Services.Core;

namespace $rootNamespace$.Pipelines.Initialize
{
    public class ConfigureWebApi
    {
        public void Process(PipelineArgs args)
        {
            GlobalConfiguration.Configure(config => config.MapHttpAttributeRoutes());
            GlobalConfiguration.Configure(ReplaceControllerSelector);
        }

        private static void ReplaceControllerSelector(HttpConfiguration config)
        {
            config.Services.Replace(typeof (IHttpControllerSelector),
                new CustomHttpControllerSelector(config, new NamespaceQualifiedUniqueNameGenerator()));
        }
    }
}
