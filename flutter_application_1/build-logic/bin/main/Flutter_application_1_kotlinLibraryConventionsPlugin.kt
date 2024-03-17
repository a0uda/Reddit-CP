/**
 * Precompiled [flutter_application_1.kotlin-library-conventions.gradle.kts][Flutter_application_1_kotlin_library_conventions_gradle] script plugin.
 *
 * @see Flutter_application_1_kotlin_library_conventions_gradle
 */
public
class Flutter_application_1_kotlinLibraryConventionsPlugin : org.gradle.api.Plugin<org.gradle.api.Project> {
    override fun apply(target: org.gradle.api.Project) {
        try {
            Class
                .forName("Flutter_application_1_kotlin_library_conventions_gradle")
                .getDeclaredConstructor(org.gradle.api.Project::class.java, org.gradle.api.Project::class.java)
                .newInstance(target, target)
        } catch (e: java.lang.reflect.InvocationTargetException) {
            throw e.targetException
        }
    }
}
