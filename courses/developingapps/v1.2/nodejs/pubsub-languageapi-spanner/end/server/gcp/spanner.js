// Copyright 2017, Google, Inc.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
const config = require('../config');

// TODO: Import the @google-cloud/spanner module

const {Spanner} = require('@google-cloud/spanner');

// END TODO

// TODO: Create a client object to access Cloud Spanner
// The Spanner(...) factory function accepts an options 
// object which is used to select which project's Cloud 
// Spanner database instance(s) should be used via the 
// projectId property. 
// The projectId is retrieved from the config module. 
// This module retrieves the project ID from the 
// GCLOUD_PROJECT environment variable.
const spanner = new Spanner({
    projectID: config.get('GCLOUD_PROJECT')
});

// END TODO

// TODO: Get a reference to the Cloud Spanner instance
const instance = spanner.instance('quiz-instance');

// END TODO

// TODO: Get a reference to the Cloud Spanner database
const database = instance.database('quiz-database');

// END TODO

// TODO: Get a reference to the Cloud Spanner table
const feedbackTable = database.table('feedback');

// END TODO

async function saveFeedback(
    { email, quiz, timestamp, rating, feedback, score }) {

    // TODO: Declare rev_email constant
    // TODO: Produce a 'reversed' email address
    // eg app.dev.student@example.org -> org_example_student_dev_app
    const rev_email = email
        .replace(/[@\.]/g, '_')
        .split('_')
        .reverse()
        .join('_');
    
    // END TODO

    // TODO: Create record object to be inserted into Spanner
    // USe Spanner.float() to convert the score property
    const record = {
        feedbackId: `${rev_email}_${quiz}_${timestamp}`,
        email,
        quiz,
        timestamp,
        rating,
        score: Spanner.float(score),
        feedback,
    };
    // END TODO

    // TODO: Insert the record into the table using await
    // use try {} catch {} and check for err.code==6 to trap
    // insert errors caused by duplicated PubSub messages
    try {
        console.log('Saving feedback');
        await feedbackTable.insert(record);
    } catch (err) {
        if (err.code === 6 ) {
            console.log("Duplicate message - feedback already saved");
        } else {
            console.error('ERROR processing feedback:', err);
        }
    }
    // END TODO
}


module.exports = {
    saveFeedback
};