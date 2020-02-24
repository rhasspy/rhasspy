import json
import unittest

import requests
from rhasspyhermes.nlu import NluIntent, NluIntentNotRecognized


class NluEnglishTests(unittest.TestCase):
    """Test natural language understanding (English)"""

    def test_http_text_to_intent(self):
        """Test text-to-intent HTTP endpoint"""
        response = requests.post(
            "http://localhost:12101/api/text-to-intent",
            data="set bedroom light to BLUE",
        )
        response.raise_for_status()

        result = response.json()

        # Original text with upper-case COLOR
        self.assertEqual(result["raw_text"], "set bedroom light to BLUE")

        # Case-corrected text
        self.assertEqual(result["text"], "set bedroom light to blue")

        # Intent name and slots
        self.assertEqual(result["intent"]["name"], "ChangeLightColor")
        self.assertEqual(result["slots"]["name"], "bedroom light")
        self.assertEqual(result["slots"]["color"], "blue")

    def test_http_text_to_intent_failure(self):
        """Test recognition failure with text-to-intent HTTP endpoint"""
        response = requests.post(
            "http://localhost:12101/api/text-to-intent", data="not a valid sentence"
        )
        response.raise_for_status()

        result = response.json()

        self.assertEqual(result["raw_text"], "not a valid sentence")
        self.assertEqual(result["text"], "not a valid sentence")

        # Empty intent name and no slots
        self.assertEqual(result["intent"]["name"], "")
        self.assertEqual(len(result["slots"]), 0)

    def test_http_text_to_intent_hermes(self):
        """Test text-to-intent HTTP endpoint (Hermes format)"""
        response = requests.post(
            "http://localhost:12101/api/text-to-intent?outputFormat=hermes",
            data="set bedroom light to BLUE",
        )
        response.raise_for_status()

        result = response.json()
        self.assertEqual(result["type"], "intent")

        nlu_intent = NluIntent.from_dict(result["value"])

        # Original text with upper-case COLOR
        self.assertEqual(nlu_intent.raw_input, "set bedroom light to BLUE")

        # Case-corrected text
        self.assertEqual(nlu_intent.input, "set bedroom light to blue")

        # Intent name and slots
        self.assertEqual(nlu_intent.intent.intentName, "ChangeLightColor")

        slots_by_name = {slot.slotName: slot for slot in nlu_intent.slots}
        self.assertIn("name", slots_by_name)
        self.assertEqual(slots_by_name["name"].value, "bedroom light")

        self.assertIn("color", slots_by_name)
        self.assertEqual(slots_by_name["color"].value, "blue")

    def test_http_text_to_intent_hermes_failure(self):
        """Test recognition failure with text-to-intent HTTP endpoint (Hermes format)"""
        response = requests.post(
            "http://localhost:12101/api/text-to-intent?outputFormat=hermes",
            data="not a valid sentence",
        )
        response.raise_for_status()

        result = response.json()
        self.assertEqual(result["type"], "intentNotRecognized")

        # Different type
        not_recognized = NluIntentNotRecognized.from_dict(result["value"])

        # Input carried forward
        self.assertEqual(not_recognized.input, "not a valid sentence")
