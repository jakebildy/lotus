allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Fix namespace issue for plugins that don't specify it
subprojects {
    val configureNamespace: (Project) -> Unit = { project ->
        plugins.withId("com.android.library") {
            val android = extensions.findByName("android")
            if (android != null) {
                val androidExtension = android as com.android.build.gradle.BaseExtension
                if (androidExtension.namespace == null) {
                    // Try to get namespace from AndroidManifest.xml
                    val manifestFile = project.file("src/main/AndroidManifest.xml")
                    if (manifestFile.exists()) {
                        val manifestContent = manifestFile.readText()
                        val packageMatch = Regex("package=\"([^\"]+)\"").find(manifestContent)
                        if (packageMatch != null) {
                            val namespace = packageMatch.groupValues[1]
                            androidExtension.namespace = namespace
                        }
                    }
                }
            }
        }
    }
    
    // Check if already evaluated
    if (project.state.executed) {
        configureNamespace(project)
    } else {
        afterEvaluate {
            configureNamespace(project)
        }
    }
}

// Force consistent JVM target for all subprojects
subprojects {
    val configureJvmTarget: (Project) -> Unit = { project ->
        plugins.withId("com.android.library") {
            val android = extensions.findByName("android")
            if (android != null) {
                val androidExtension = android as com.android.build.gradle.BaseExtension
                
                // Set Java compile options
                androidExtension.compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_11
                    targetCompatibility = JavaVersion.VERSION_11
                }
                
                // Set Kotlin JVM target
                tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                    kotlinOptions {
                        jvmTarget = "11"
                    }
                }
            }
        }
    }
    
    // Check if already evaluated
    if (project.state.executed) {
        configureJvmTarget(project)
    } else {
        afterEvaluate {
            configureJvmTarget(project)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}