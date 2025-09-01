import kotlinx.coroutines.delay
import kotlinx.coroutines.runBlocking
import org.jmailen.gradle.kotlinter.tasks.LintTask

open class ExecOperationsTask @Inject constructor(@Internal val execOperations: ExecOperations) : DefaultTask()

plugins {
    kotlin("jvm") version "1.9.0"
    application
    id("org.jmailen.kotlinter") version "3.16.0"
}

group = "org.example"
version = "2.1.4"

repositories {
    mavenCentral()
    google()
}

tasks.withType<Test> {
    useJUnitPlatform()
}

dependencies {
    implementation(kotlin("stdlib"))
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.6.2")
    testImplementation("org.spekframework.spek2:spek-dsl-jvm:2.0.18")
    testRuntimeOnly("org.spekframework.spek2:spek-runner-junit5:2.0.18")
    testRuntimeOnly("org.jetbrains.kotlin:kotlin-reflect:1.6.10")
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.8.2")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.8.2")
}

tasks.getByName<Test>("test") {
    runBlocking {
        useJUnitPlatform()
        delay(1000)
        finalizedBy("testReportExam")
    }
}

tasks.register<TestReportExam>("testReportExam")

tasks.register<LintTask>("lint") {
    group = "verification"
    source(files("src/main"))
    reports.set(
        mapOf(
            "plain" to file("build/lint-result/lint-report.txt"),
            "json" to file("build/lint-result/lint-report.json")
        )
    )
}

tasks.register<ExecOperationsTask>("runMainCriteriaTest") {
    doFirst {
        execOperations.exec {
            commandLine("./gradlew", "test")
            args("--tests", "ExamTestMain", "-q")
        }
    }
}

tasks.register<ExecOperationsTask>("runOptionalCriteriaTest") {
    doFirst {
        execOperations.exec {
            commandLine("./gradlew", "test")
            args("--tests", "ExamTestOptional", "-q")
        }
    }
}

tasks.register<ExecOperationsTask>("runAllTest") {
    doFirst {
        execOperations.exec() {
            commandLine("./gradlew", "test")
            args("--continue", "-q")
        }
    }
}
