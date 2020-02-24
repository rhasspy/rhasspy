import json
import unittest
from pathlib import Path

import requests
from rhasspyhermes.asr import AsrTextCaptured
from rhasspyhermes.nlu import NluIntent


class AsrEnglishTests(unittest.TestCase):
    """Test automated speech recognition (English)"""

    def setUp(self):
        self.wav_bytes = Path(
            "wav/en/turn_on_the_living_room_lamp.wav"
        ).read_bytes()

    def test_http_speech_to_text(self):
        """Test speech-to-text HTTP endpoint"""
        response = requests.post(
            "http://localhost:12101/api/speech-to-text", data=self.wav_bytes
        )
        response.raise_for_status()

        text = response.content.decode()
        self.assertEqual(text, "turn on the living room lamp")

    def test_http_speech_to_text_json(self):
        """Text speech-to-text HTTP endpoint (Rhasspy JSON format)"""
        response = requests.post(
            "http://localhost:12101/api/speech-to-text",
            data=self.wav_bytes,
            headers={"Accept": "application/json"},
        )
        response.raise_for_status()

        result = response.json()
        self.assertEqual(result["text"], "turn on the living room lamp")

    def test_http_speech_to_text_hermes(self):
        """Text speech-to-text HTTP endpoint (Hermes format)"""
        response = requests.post(
            "http://localhost:12101/api/speech-to-text?outputFormat=hermes",
            data=self.wav_bytes,
        )
        response.raise_for_status()

        result = response.json()
        self.assertEqual(result["type"], "textCaptured")

        text_captured = AsrTextCaptured.from_dict(result["value"])

        self.assertEqual(text_captured.text, "turn on the living room lamp")

    def test_http_speech_to_intent(self):
        response = requests.post(
            "http://localhost:12101/api/speech-to-intent", data=self.wav_bytes
        )
        response.raise_for_status()

        result = response.json()
        self.assertEqual(result["intent"]["name"], "ChangeLightState")
        self.assertEqual(result["text"], "turn on the living room lamp")
        self.assertEqual(result["slots"]["name"], "living room lamp")
        self.assertEqual(result["slots"]["state"], "on")

    def test_http_speech_to_intent_hermes(self):
        response = requests.post(
            "http://localhost:12101/api/speech-to-intent?outputFormat=hermes",
            data=self.wav_bytes,
        )
        response.raise_for_status()

        result = response.json()
        self.assertEqual(result["type"], "intent")

        nlu_intent = NluIntent.from_dict(result["value"])

        self.assertEqual(nlu_intent.raw_input, "turn on the living room lamp")
        self.assertEqual(nlu_intent.input, "turn on the living room lamp")

        # Intent name and slots
        self.assertEqual(nlu_intent.intent.intentName, "ChangeLightState")

        slots_by_name = {slot.slotName: slot for slot in nlu_intent.slots}
        self.assertIn("name", slots_by_name)
        self.assertEqual(slots_by_name["name"].value, "living room lamp")

        self.assertIn("state", slots_by_name)
        self.assertEqual(slots_by_name["state"].value, "on")
