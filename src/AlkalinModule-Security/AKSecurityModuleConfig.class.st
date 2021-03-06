Class {
	#name : #AKSecurityModuleConfig,
	#superclass : #Object,
	#instVars : [
		'userProviderBuilders',
		'authenticatorBuilders'
	],
	#category : #'AlkalinModule-Security-Module'
}

{ #category : #adding }
AKSecurityModuleConfig >> addAuthenticator: aBlock [
	| auth |
	auth := AKAuthenticatorBuilder new.
	aBlock value: auth.
	authenticatorBuilders add: auth
]

{ #category : #adding }
AKSecurityModuleConfig >> addUserProvider: aBlock [
	| providerBuilder |
	providerBuilder := AKUserProviderBuilder new.
	aBlock value: providerBuilder.
	userProviderBuilders add: providerBuilder
]

{ #category : #building }
AKSecurityModuleConfig >> buildAuthenticatorMap [
	| authMap userProviders manager |
	authMap := AKAuthenticatorMap new.
	userProviders := userProviderBuilders collect: [ :b | b buildProvider ].
	manager := AKUserProviderManager withProviders: userProviders.
	authenticatorBuilders do: [ :b | 
			| auth |
			auth := b buildAuthenticator.
			auth userProviderManager: manager.
			authMap map: b requestMatcher to: auth ].
	^ authMap
]

{ #category : #initialization }
AKSecurityModuleConfig >> initialize [
	super initialize.
	authenticatorBuilders := OrderedCollection new.
	userProviderBuilders := OrderedCollection new
]

{ #category : #testing }
AKSecurityModuleConfig >> isConfigured [
	^ authenticatorBuilders isNotEmpty
]
