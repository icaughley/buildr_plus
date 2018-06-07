#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

BuildrPlus::FeatureManager.feature(:libs) do |f|
  f.enhance(:Config) do

    def mustache
      %w(com.github.spullara.mustache.java:compiler:jar:0.8.15)
    end

    def javacsv
      %w(net.sourceforge.javacsv:javacsv:jar:2.1)
    end

    def geotools_for_geolatte
      %w(org.geotools:gt-main:jar:9.4 org.geotools:gt-metadata:jar:9.4 org.geotools:gt-api:jar:9.4 org.geotools:gt-epsg-wkt:jar:9.4 org.geotools:gt-opengis:jar:9.4 org.geotools:gt-transform:jar:9.4 org.geotools:gt-geometry:jar:9.4 org.geotools:gt-jts-wrapper:jar:9.4 org.geotools:gt-referencing:jar:9.4 net.java.dev.jsr-275:jsr-275:jar:1.0-beta-2 java3d:vecmath:jar:1.3.2 javax.media:jai_core:jar:1.1.3)
    end

    def jts
      %w(com.vividsolutions:jts:jar:1.13)
    end

    # Support geo libraries for geolatte
    def geolatte_support
      self.jts + self.slf4j
    end

    def geolatte_geom
      %w(org.geolatte:geolatte-geom:jar:0.13)
    end

    def geolatte_geom_jpa
      %w(org.realityforge.geolatte.jpa:geolatte-geom-jpa:jar:0.2)
    end

    def jetbrains_annotations
      %w(org.jetbrains:annotations:jar:15.0)
    end

    def findbugs_provided
      %w(com.google.code.findbugs:jsr305:jar:3.0.2 com.google.code.findbugs:annotations:jar:3.0.1)
    end

    def ee_provided
      %w(javax:javaee-api:jar:7.0) + self.findbugs_provided + self.jetbrains_annotations
    end

    def glassfish_embedded
      %w(fish.payara.extras:payara-embedded-all:jar:4.1.2.172 fish.payara.api:payara-api:jar:4.1.2.172)
    end

    def eclipselink
      'org.eclipse.persistence:eclipselink:jar:2.6.0'
    end

    def mockito
      %w(org.mockito:mockito-all:jar:1.10.19)
    end

    def objenesis
      %w(org.objenesis:objenesis:jar:2.5.1)
    end

    def powermock_version
      '1.6.6'
    end

    def powermock_javaagent
      "org.powermock:powermock-module-javaagent:jar:#{powermock_version}"
    end

    def powermock
      %W(
        org.powermock:powermock-core:jar:#{powermock_version}
        org.powermock:powermock-reflect:jar:#{powermock_version}
        org.powermock:powermock-module-testng-common:jar:#{powermock_version}
        org.powermock:powermock-module-testng:jar:#{powermock_version}
        org.powermock:powermock-api-mockito:jar:#{powermock_version}
        org.powermock:powermock-api-mockito-common:jar:#{powermock_version}
        org.powermock:powermock-api-support:jar:#{powermock_version}
        org.javassist:javassist:jar:3.21.0-GA
        org.powermock:powermock-module-testng-agent:jar:#{powermock_version}
      #{powermock_javaagent}
      ) + self.objenesis
    end

    def jackson_annotations
      %w(com.fasterxml.jackson.core:jackson-annotations:jar:2.8.8)
    end

    def jackson_core
      %w(com.fasterxml.jackson.core:jackson-core:jar:2.8.8)
    end

    def jackson_databind
      %w(com.fasterxml.jackson.core:jackson-databind:jar:2.8.8)
    end

    def jackson_datatype_jdk8
      %w(com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.8.8)
    end

    def jackson_module_kotlin
      %w(com.fasterxml.jackson.module:jackson-module-kotlin:jar:2.8.8)
    end

    def jackson_gwt_support
      self.jackson_core + self.jackson_databind + self.jackson_annotations
    end

    def anodoc
      %w(org.realityforge.anodoc:anodoc:jar:1.0.0)
    end

    def braincheck_version
      '1.5.0'
    end

    def braincheck
      %W(org.realityforge.braincheck:braincheck:jar:#{braincheck_version}) + self.anodoc
    end

    def jsinterop
      %w(com.google.jsinterop:jsinterop-annotations:jar:1.0.2 com.google.jsinterop:jsinterop-annotations:jar:sources:1.0.2)
    end

    def jsinterop_base
      %w(com.google.jsinterop:base:jar:1.0.0-RC1 com.google.jsinterop:base:jar:sources:1.0.0-RC1) + self.jsinterop
    end

    def elemental_version
      '1.0.0-RC1'
    end

    def elemental2_core
      %W(com.google.elemental2:elemental2-core:jar:#{elemental_version}) + self.jsinterop_base
    end

    def elemental2_dom
      %W(com.google.elemental2:elemental2-dom:jar:#{elemental_version}) + self.elemental2_core
    end

    def elemental2_promise
      %W(com.google.elemental2:elemental2-promise:jar:#{elemental_version}) + self.elemental2_core
    end

    def elemental2_webstorage
      %W(com.google.elemental2:elemental2-webstorage:jar:#{elemental_version}) + self.elemental2_dom
    end

    def gwt_user
      %w(com.google.gwt:gwt-user:jar:2.8.2 org.w3c.css:sac:jar:1.3) + self.jsinterop
    end

    def gwt_servlet
      %w(com.google.gwt:gwt-servlet:jar:2.8.2)
    end

    def gwt_dev
      'com.google.gwt:gwt-dev:jar:2.8.2'
    end

    def javax_inject
      %w(javax.inject:javax.inject:jar:1)
    end

    def javax_inject_gwt
      %w(javax.inject:javax.inject:jar:sources:1) + self.javax_inject
    end

    def gwt_webpoller
      %w(org.realityforge.gwt.webpoller:gwt-webpoller:jar:0.9.6)
    end

    def gwt_datatypes
      %w(org.realityforge.gwt.datatypes:gwt-datatypes:jar:0.9)
    end

    def gwt_ga
      %w(org.realityforge.gwt.ga:gwt-ga:jar:0.5)
    end

    def gwt_mmvp
      %w(org.realityforge.gwt.mmvp:gwt-mmvp:jar:0.9)
    end

    def gwt_lognice
      %w(org.realityforge.gwt.lognice:gwt-lognice:jar:0.6)
    end

    def gwt_appcache_client
      %w(org.realityforge.gwt.appcache:gwt-appcache-client:jar:1.0.11 org.realityforge.gwt.appcache:gwt-appcache-linker:jar:1.0.11)
    end

    def gwt_appcache_server
      %w(org.realityforge.gwt.appcache:gwt-appcache-server:jar:1.0.11)
    end

    # The appcache code required to exist on gwt path during compilation
    def gwt_appcache
      self.gwt_appcache_client + self.gwt_appcache_server
    end

    def gwt_cache_filter
      %w(org.realityforge.gwt.cache-filter:gwt-cache-filter:jar:0.7)
    end

    def field_filter
      %w(org.realityforge.rest.field_filter:rest-field-filter:jar:0.4)
    end

    def graphql_java
      %w(com.graphql-java:graphql-java:jar:3.0.0) + self.slf4j + self.antlr4_runtime
    end

    def graphql_java_tools
      %w(
        com.esotericsoftware:reflectasm:jar:1.11.3
        com.graphql-java:graphql-java-tools:jar:3.2.1
        org.jetbrains.kotlin:kotlin-reflect:jar:1.1.1
        org.jetbrains.kotlin:kotlin-stdlib:jar:1.1.1
        org.jetbrains.kotlin:kotlin-stdlib:jar:1.1.3-2
        org.ow2.asm:asm:jar:5.0.4
        ru.vyarus:generics-resolver:jar:2.0.1
      ) + self.graphql_java +
        self.jackson_annotations +
        self.jackson_core +
        self.jackson_databind +
        self.jackson_datatype_jdk8 +
        self.jackson_module_kotlin +
        self.guava + # Expected 21.0
        self.jetbrains_annotations
    end

    def graphql_java_servlet
      %w(
        com.graphql-java:graphql-java-servlet:jar:4.0.0
        commons-fileupload:commons-fileupload:jar:1.3.3
        commons-io:commons-io:jar:2.5
      ) + self.graphql_java_tools
    end

    def graphql_domgen_support
      %w(org.realityforge.keycloak.domgen:graphql-domgen-support:jar:1.2.0)
    end

    def antlr4_runtime
      %w(org.antlr:antlr4-runtime:jar:4.5.1)
    end

    def rest_criteria
      %w(org.realityforge.rest.criteria:rest-criteria:jar:0.9.6) +
        self.antlr4_runtime +
        self.field_filter
    end

    def commons_logging
      %w(commons-logging:commons-logging:jar:1.2)
    end

    def commons_codec
      %w(commons-codec:commons-codec:jar:1.9)
    end

    def bouncycastle
      %w(org.bouncycastle:bcprov-jdk15on:jar:1.52 org.bouncycastle:bcpkix-jdk15on:jar:1.52)
    end

    def proxy_servlet
      self.httpclient + %w(org.realityforge.proxy-servlet:proxy-servlet:jar:0.2.0)
    end

    def httpclient
      %w(org.apache.httpcomponents:httpclient:jar:4.5 org.apache.httpcomponents:httpcore:jar:4.4.1) +
        self.commons_logging + self.commons_codec
    end

    def failsafe
      %w(net.jodah:failsafe:jar:1.0.3)
    end

    def keycloak_gwt
      %w(org.realityforge.gwt.keycloak:gwt-keycloak:jar:0.2)
    end

    def keycloak_domgen_support
      %w(org.realityforge.keycloak.domgen:keycloak-domgen-support:jar:1.4)
    end

    def keycloak_authfilter
      %w(org.realityforge.keycloak.client.authfilter:keycloak-jaxrs-client-authfilter:jar:0.2)
    end

    def keycloak_converger
      'org.realityforge.keycloak.converger:keycloak-converger:jar:1.6'
    end

    def jboss_logging
      %w(org.jboss.logging:jboss-logging:jar:3.3.0.Final)
    end

    def keycloak_core
      %w(
        org.keycloak:keycloak-core:jar:2.0.0.Final
        org.keycloak:keycloak-common:jar:2.0.0.Final
      ) + self.bouncycastle
    end

    def keycloak
      %w(
        org.keycloak:keycloak-servlet-filter-adapter:jar:2.0.0.Final
        org.keycloak:keycloak-adapter-spi:jar:2.0.0.Final
        org.keycloak:keycloak-adapter-core:jar:2.0.0.Final
        org.realityforge.org.keycloak:keycloak-servlet-adapter-spi:jar:2.0.0.Final
      ) + self.keycloak_core + self.keycloak_domgen_support + self.httpclient + self.jboss_logging
    end

    def simple_keycloak_service
      %w(org.realityforge.keycloak.sks:simple-keycloak-service:jar:0.1)
    end

    def guava
      %w(com.google.guava:guava:jar:23.3-jre)
    end

    def javapoet
      %w(com.squareup:javapoet:jar:1.8.0) + self.guava
    end

    def arez_version
      '0.90'
    end

    def arez_annotations
      %W(
        org.realityforge.arez:arez-annotations:jar:#{arez_version}
      )
    end

    def arez
      %W(
        org.realityforge.arez:arez-core:jar:#{arez_version}
        org.realityforge.arez:arez-component:jar:#{arez_version}
      ) + self.braincheck + self.arez_annotations
    end

    def arez_processor
      %W(org.realityforge.arez:arez-processor:jar:#{arez_version})
    end

    def arez_spytools
      %w(org.realityforge.arez.spytools:arez-spytools:jar:0.11)
    end

    def router_fu_version
      '0.10'
    end

    def router_fu_annotations
      %W(org.realityforge.router.fu:router-fu-annotations:jar:#{router_fu_version})
    end

    def router_fu
      %W(org.realityforge.router.fu:router-fu-core:jar:#{router_fu_version}) + self.braincheck + self.router_fu_annotations
    end

    def router_fu_processor
      %W(org.realityforge.router.fu:router-fu-processor:jar:#{router_fu_version})
    end

    def react4j_version
      '0.72'
    end

    def react4j
      %W(
        org.realityforge.react4j:react4j-annotations:jar:#{react4j_version}
        org.realityforge.react4j:react4j-core:jar:#{react4j_version}
        org.realityforge.react4j:react4j-dom:jar:#{react4j_version}
      ) + self.elemental2_dom + self.elemental2_promise
    end

    def react4j_processor
      %W(org.realityforge.react4j:react4j-processor:jar:#{react4j_version})
    end

    def react4j_arez
      %W(org.realityforge.react4j:react4j-arez:jar:#{react4j_version})
    end

    def replicant_version
      '5.99-arez-b27'
    end

    def replicant_shared
      %W(org.realityforge.replicant:replicant-shared:jar:#{replicant_version})
    end

    def replicant_client
      %W(org.realityforge.replicant:replicant-client:jar:#{replicant_version}) +
        self.replicant_shared +
        self.gwt_webpoller +
        self.gwt_datatypes +
        self.elemental2_webstorage +
        # ee provided is for json API
        self.ee_provided
    end

    def replicant_server
      %W(org.realityforge.replicant:replicant-server:jar:#{replicant_version}) + self.replicant_shared + self.gwt_rpc
    end

    def gwt_rpc
      self.gwt_datatypes + self.jackson_gwt_support + self.gwt_servlet
    end

    def guice
      %w(aopalliance:aopalliance:jar:1.0 org.ow2.asm:asm:jar:5.0.3 au.com.stocksoftware.com.google.inject:guice:jar:4.1.1-stock)
    end

    def awaitility
      %w(org.awaitility:awaitility:jar:2.0.0)
    end

    def dagger_version
      '2.15'
    end

    def dagger_compile
      %W(
          com.google.dagger:dagger:jar:#{dagger_version}
      )
    end

    def dagger
      self.dagger_compile + self.javax_inject
    end

    def dagger_compiler
      %W(
          com.google.dagger:dagger-spi:jar:#{dagger_version}
          com.google.dagger:dagger-producers:jar:#{dagger_version}
          com.google.dagger:dagger-compiler:jar:#{dagger_version}
          com.google.googlejavaformat:google-java-format:jar:1.4
          com.google.errorprone:javac-shaded:jar:9-dev-r4023-3
        ) + self.javapoet + self.dagger
    end

    def dagger_gwt
      %W(
          com.google.dagger:dagger:jar:sources:#{dagger_version}
          com.google.dagger:dagger-gwt:jar:sources:#{dagger_version}
      ) + self.dagger + self.javax_inject_gwt
    end

    def testng_version
      '6.11'
    end

    def testng
      %W(org.testng:testng:jar:#{testng_version})
    end

    def jndikit
      %w(org.realityforge.jndikit:jndikit:jar:1.4)
    end

    def guiceyloops
      self.guiceyloops_gwt + self.glassfish_embedded
    end

    def guiceyloops_lib
      'org.realityforge.guiceyloops:guiceyloops:jar:0.95'
    end

    def guiceyloops_gwt
      [guiceyloops_lib] + self.mockito + self.guice + self.testng
    end

    def glassfish_timers_domain
      %W(org.realityforge.glassfish.timers#{BuildrPlus::Db.pgsql? ? '.pg' : ''}:glassfish-timers-domain:json:0.6)
    end

    def glassfish_timers_db
      %W(org.realityforge.glassfish.timers#{BuildrPlus::Db.pgsql? ? '.pg' : ''}:glassfish-timers-db:jar:0.6)
    end

    def slf4j
      %w(org.slf4j:slf4j-api:jar:1.6.6 org.slf4j:slf4j-jdk14:jar:1.6.6)
    end

    def greenmail
      %w(com.icegreen:greenmail:jar:1.4.1) + self.slf4j
    end

    def greenmail_server
      'com.icegreen:greenmail-webapp:war:1.4.1'
    end

    def jtds
      %w(net.sourceforge.jtds:jtds:jar:1.3.1)
    end

    def postgresql
      %w(org.postgresql:postgresql:jar:9.2-1003-jdbc4)
    end

    def postgis
      %w(org.postgis:postgis-jdbc:jar:1.3.3)
    end

    def db_drivers
      return self.jtds if BuildrPlus::Db.mssql?
      return self.postgresql + (BuildrPlus::FeatureManager.activated?(:geolatte) ? self.postgis : []) if BuildrPlus::Db.pgsql?
      []
    end
  end
end
