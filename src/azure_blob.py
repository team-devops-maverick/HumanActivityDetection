from azure.storage.blob import BlobServiceClient

CONNECTION_STRING = "<YOUR CONNECTION STRING>"
CONTAINER = "videos"

blob_service = BlobServiceClient.from_connection_string(CONNECTION_STRING)
container = blob_service.get_container_client(CONTAINER)


def list_videos():
    return [blob.name for blob in container.list_blobs()]


def download_video(blob_name, output_path):
    blob = container.get_blob_client(blob_name)

    with open(output_path, "wb") as f:
        blob.download_blob().readinto(f)
