import Foundation

class NSDebugDatabaseUploadHelper {
    private var deviceToken: String {
        if let deviceToken: String = UserDefaults.standard.string(forKey: "org.dpppt.unique_device_token") {
            return deviceToken
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: "org.dpppt.unique_device_token")
            return uuid
        }
    }

    private struct UploadServerError: Decodable {
        let error: String?
        let message: String?
        let path: String
        let status: Int
        let timestamp: Double
    }

    struct UploadError: Error {
        let message: String
    }

    func uploadDatabase(username: String, completion: ((Result<String, UploadError>) -> Void)?) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let fileUrl = documentsDirectory.appendingPathComponent("DP3T_tracing_db").appendingPathExtension("sqlite")

        guard let databaseData = try? Data(contentsOf: fileUrl),
            let url = URL(string: "https://dp3tdemoupload.azurewebsites.net/upload") else {
            completion?(.failure(UploadError(message: "Couldn't read file")))
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let fileName = dateFormatter.string(from: Date()) + "_" + username + "_" + deviceToken + "_dp3t_callibration_db.sqlite"

        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/sqlite\r\n\r\n".data(using: .utf8)!)
        data.append(databaseData)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion?(.failure(UploadError(message: error.localizedDescription)))
                } else if let data = responseData, let jsonError = try? JSONDecoder().decode(UploadServerError.self, from: data) {
                    completion?(.failure(UploadError(message: jsonError.error ?? "Server Error")))
                } else if let data = responseData, let serverMessage = String(data: data, encoding: .utf8) {
                    completion?(.success(serverMessage))
                } else {
                    completion?(.failure(UploadError(message: "Unknown error")))
                }
            }
        }).resume()
    }
}
