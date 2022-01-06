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
const Spanner = require('@google-cloud/spanner');

const spanner = Spanner();

const instance = spanner.instance('quiz-instance');
const database = instance.database('quiz-database');
const table = database.table('feedback');


function saveFeedback(
    { email, quiz, timestamp, rating, feedback, score }) {
    const rev_email = email
        .replace(/[@\.]/g, '_')
        .split('_')
        .reverse()
        .join('_');
    const record = {
        feedbackId: `${rev_email}_${quiz}_${timestamp}`,
        email,
        quiz,
        timestamp,
        rating,
        score: spanner.float(score),
        feedback,
    };
    console.log('Feedback saved');
    return table.insert(record);
}


module.exports = {
    saveFeedback
};