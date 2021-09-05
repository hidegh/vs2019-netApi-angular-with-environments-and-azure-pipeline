using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.SpaServices.AngularCli;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System.Diagnostics;

namespace SP.Test
{
    public class Startup
    {
        protected const string ClientAppPath = "../SP.Test.Client";
        protected const string ClientPublishPath = "spa-client";
        protected const string ClientAngularUrl = "http://localhost:4280";

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllersWithViews();
            // In production, the Angular files will be served from this directory
            services.AddSpaStaticFiles(configuration =>
            {
                configuration.RootPath = ClientPublishPath;
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            if (!env.IsDevelopment())
            {
                app.UseSpaStaticFiles();
            }

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller}/{action=Index}/{id?}");
            });

            app.UseSpa(spa =>
            {
                const bool doNotAttachSpa = false;

                const bool startWithApi = false;
                const bool forceLocalEnv = true;

                var scriptCommand = "start -- --configuration " + (forceLocalEnv ? "local" : env.EnvironmentName.ToLower());

                // To learn more about options for serving an Angular SPA from ASP.NET Core,
                // see https://go.microsoft.com/fwlink/?linkid=864501               
                spa.Options.StartupTimeout = new System.TimeSpan(0, 15, 0);
                spa.Options.SourcePath = ClientAppPath;

                if (Debugger.IsAttached && doNotAttachSpa == false)
                {
                    // when serving independently use : spa.UseProxyToSpaDevelopmentServer("http://localhost:4290");
                    // when serving via .NET, use :     spa.UseAngularCliServer(npmScript: "start -- --configuration " + env.EnvironmentName.ToLower());
                    if (startWithApi)
                        spa.UseAngularCliServer(npmScript: scriptCommand);
                    else
                        spa.UseProxyToSpaDevelopmentServer(ClientAngularUrl);
                }
            });

        }
    }
}
