// Placeholder: encryption is currently disabled.
// docId is temporarily set to email until AES key management is finalized.
class UidEncryptor {
  UidEncryptor(String key32);

  String toDocId(String provider, String email) => email;

  String fromDocId(String docId) => docId;
}
