if [ ! $3 ]; then
  echo "ERROR: This command needs arguments
Example: $0 <username> <password> <image_name>
"
    exit 1;
fi

docker login -u $1 -p $2
docker push $3