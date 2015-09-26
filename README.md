#  Challenge

1. Read the Fyber Offer API specification at
[API spec](http://developer.fyber.com/content/current/ios/offer-wall/offer-api/)
2. Create a form asking for these parameters (see the specs.):
 * uid
 * pub0
 * page
3. Make the request to the API passing the params and the authenticatio4.
4. Get the result from the response.
5. Check the hash in the response to make sure that it is a real response.
6. Render the offers in a view
 * If we have offers there we render them (title, thumbnail lowres andb.
 * If we have no offers there we render a message like ‘No offers ava available’.
7. Deploy your solution so that we can interact with it in a web browser.
8. Running rake at the root directory of your project should run the tests.

# Solution

1. Framework **rails** is choosen.
1. Model **OffersRequest** is created that is responsible for all the details to perform the request to the API and processing the response.
It keeps the parameters to be obtained form the form. Additionally it keeps some data coming back in response:
 * number of pages
 * number of records
1. Model **Offer** is created that keeps the data of the offers to be listed in the view.
1. Controller and views are created to accept the parameters from the form and showing the received offers in a table.
