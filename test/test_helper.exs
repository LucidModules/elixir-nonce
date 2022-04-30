alias LmNonce.Api.Nonce
alias LmNonce.Api.NonceFactory

Mox.defmock(NonceMock, for: Nonce)
Application.put_env(:lm_nonce, :nonce, NonceMock)

Mox.defmock(NonceFactoryMock, for: NonceFactory)
Application.put_env(:lm_nonce, :nonce_factory, NonceFactoryMock)

ExUnit.start()
