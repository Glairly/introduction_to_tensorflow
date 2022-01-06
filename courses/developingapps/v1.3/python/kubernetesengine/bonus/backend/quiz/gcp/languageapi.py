# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# TODO: Import the language module

from google.cloud import language

# END TODO

# TODO: Import enums and types

from google.cloud.language import enums
from google.cloud.language import types

# END TODO


# TODO: Create the Language API client

lang_client = language.LanguageServiceClient()

# END TODO

"""
Returns sentiment analysis score
- create document from passed text
- do sentiment analysis using natural language applicable
- return the sentiment score
"""
def analyze(text):

    # TODO: Create a Document object

    doc = types.Document(content=text, type=enums.Document.Type.PLAIN_TEXT)

    # END TODO

    # TODO: Analyze the sentiment

    sentiment = lang_client.analyze_sentiment(document=doc).document_sentiment

    # END TODO


    # TODO: Return the sentiment score

    return sentiment.score

    # END TODO