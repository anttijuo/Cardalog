const AWS = require('aws-sdk');
const docClient = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    try {
        // Parameters to query DynamoDB table
        const params = {
            TableName: 'cardalog-card-data',
            Key: {
                primaryKeyCardalog: 'testorino'
            }
        };

        // Query DynamoDB table
        const data = await docClient.get(params).promise();

        // Log the retrieved data
        console.log('Retrieved data from DynamoDB:', data);

        // Return the retrieved item
        return {
            statusCode: 200,
            body: JSON.stringify(data.Item)
        };
    } catch (error) {
        console.error('Error retrieving data from DynamoDB:', error);

        // Return an error response
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Internal Server Error' })
        };
    }
};