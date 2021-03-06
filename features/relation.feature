Feature: Relations support
  In order to use a hypermedia API
  As a client software developer
  I need to be able to update relations between resources

  @createSchema
  Scenario: Create a related dummy
    When I send a "POST" request to "/related_dummies" with body:
    """
    {}
    """
    Then the response status code should be 201
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be equal to:
    """
    {
      "@context": "/contexts/RelatedDummy",
      "@id": "/related_dummies/1",
      "@type": "https://schema.org/Product",
      "unknown": null,
      "age": null,
      "symfony": "symfony"
    }
    """

  Scenario: Create a dummy with relations
    When I send a "POST" request to "/dummies" with body:
    """
    {
      "name": "Dummy with relations",
      "relatedDummy": "http://example.com/related_dummies/1",
      "relatedDummies": [
        "/related_dummies/1"
      ]
    }
    """
    Then the response status code should be 201
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be equal to:
    """
    {
      "@context": "/contexts/Dummy",
      "@id": "/dummies/1",
      "@type": "Dummy",
      "name": "Dummy with relations",
      "dummy": null,
      "dummyDate": null,
      "relatedDummy": "/related_dummies/1",
      "relatedDummies": [
        "/related_dummies/1"
      ]
    }
    """

  Scenario: Filter on a relation
    When I send a "GET" request to "/dummies?relatedDummy=%2Frelated_dummies%2F1"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be equal to:
    """
    {
      "@context": "/contexts/Dummy",
      "@id": "/dummies",
      "@type": "hydra:PagedCollection",
      "hydra:totalItems": 1,
      "hydra:itemsPerPage": 3,
      "hydra:firstPage": "/dummies",
      "hydra:lastPage": "/dummies",
      "hydra:member": [
        {
          "@id": "/dummies/1",
          "@type": "Dummy",
          "name": "Dummy with relations",
          "dummy": null,
          "dummyDate": null,
          "relatedDummy": "/related_dummies/1",
          "relatedDummies": [
            "/related_dummies/1"
          ]
        }
      ]
    }
    """

  Scenario: Embed a relation in the parent object
      When I send a "POST" request to "/relation_embedders" with body:
      """
      {
        "related": "/related_dummies/1"
      }
      """
      Then the response status code should be 201
      And the response should be in JSON
      And the header "Content-Type" should be equal to "application/ld+json"
      And the JSON should be equal to:
      """
      {
        "@context": "/contexts/RelationEmbedder",
        "@id": "/relation_embedders/1",
        "@type": "RelationEmbedder",
        "krondstadt": "Krondstadt",
        "anotherRelated": null,
        "related": {
            "@id": "/related_dummies/1",
            "@type": "https://schema.org/Product",
            "symfony": "symfony"
        }
      }
      """

  Scenario: Create an existing relation
    When I send a "POST" request to "/relation_embedders" with body:
    """
      {
        "anotherRelated": {
          "symfony": "laravel"
        }
      }
      """
    Then the response status code should be 201
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be equal to:
    """
    {
      "@context": "/contexts/RelationEmbedder",
      "@id": "/relation_embedders/2",
      "@type": "RelationEmbedder",
      "krondstadt": "Krondstadt",
      "anotherRelated": {
        "@id": "/related_dummies/2",
        "@type": "https://schema.org/Product",
        "symfony": "laravel"
      },
      "related": null
    }
    """

  @dropSchema
  Scenario: Update an existing relation
    When I send a "POST" request to "/relation_embedders" with body:
    """
      {
        "anotherRelated": {
          "@id": "/related_dummies/2",
          "@type": "https://schema.org/Product",
          "symfony": "phalcon"
        }
      }
      """
    Then the response status code should be 201
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json"
    And the JSON should be equal to:
    """
    {
      "@context": "/contexts/RelationEmbedder",
      "@id": "/relation_embedders/3",
      "@type": "RelationEmbedder",
      "krondstadt": "Krondstadt",
      "anotherRelated": {
        "@id": "/related_dummies/2",
        "@type": "https://schema.org/Product",
        "symfony": "phalcon"
      },
      "related": null
    }
    """
