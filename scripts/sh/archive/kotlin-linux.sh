# print border around string
border()
{
    title="| $1 |"
    edge=$(echo "$title" | sed 's/./-/g')
    echo "$edge"
    echo "$title"
    echo "$edge"
}

border "Installing Kotlin"
echo ""
sudo snap install --classic kotlin
echo""

border "Downloading Gradle"
echo ""
wget https://services.gradle.org/distributions/gradle-6.4.1-bin.zip -P /tmp
echo""

sudo unzip -d /opt/gradle /tmp/gradle-*.zip

border "Setting-up environment variables"
echo ""
sudo rm /etc/profile.d/gradle.sh
sudo echo 'export GRADLE_HOME=/opt/gradle/gradle-6.4.1' | sudo tee -a /etc/profile.d/gradle.sh
sudo echo 'export PATH=${GRADLE_HOME}/bin:${PATH}' | sudo tee -a /etc/profile.d/gradle.sh

source /etc/profile.d/gradle.sh
echo ""

border "Installing maven"
sudo apt install maven

border "Verifying install"
mvn -version
gradle -v
