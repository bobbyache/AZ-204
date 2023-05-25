Setting environment variables in your container instances allows you to provide dynamic configuration of the application or script run by the container. These environment variables are similar to the --env command-line argument to docker run.

If you need to pass secrets as environment variables, Azure Container Instances supports secure values for both Windows and Linux containers.

Objects with secure values are intended to hold sensitive information like passwords or keys for your application. Using secure values for environment variables is both safer and more flexible than including it in your container's image.

Environment variables with secure values aren't visible in your container's properties. Their values can be accessed only from within the container. For example, container properties viewed in the Azure portal or Azure CLI display only a secure variable's name, not its value.

Set a secure environment variable by specifying the secureValue property instead of the regular value for the variable's type. The two variables defined in the following YAML demonstrate the two variable types.