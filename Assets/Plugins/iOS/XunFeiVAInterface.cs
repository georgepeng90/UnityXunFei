using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using AOT;

namespace XunFeiVA
{
	public static class XunFeiVAInterface
	{
		public delegate void internal_ISR_ResultCallback(string results, bool isLast);
		public delegate void internal_ISR_ErrorCallback(int errorCode, int errorType);
		public delegate void internal_ISR_VolumeCallback(int volume);
		public delegate void internal_ISR_SpeechBeginCallback();
		public delegate void internal_ISR_SpeechStopCallback();
		

		public static event internal_ISR_ResultCallback isrResultEvent;
		public static event internal_ISR_ErrorCallback isrErrorEvent;
		public static event internal_ISR_VolumeCallback isrVolumeEvent;
		public static event internal_ISR_SpeechBeginCallback isrSpeechBeginEvent;
		public static event internal_ISR_SpeechStopCallback isrSpeechStopEvent;

		#if !UNITY_EDITOR

		[DllImport("__Internal")]
		private static extern void XunFeiVA_Init(string appid);
		public static void Init(string appid)
		{
			XunFeiVA_Init(appid);
			XunFeiVA_ISR_SetupCallbacks(
				_ISR_ResultCallback,
				_ISR_ErrorCallback,
				_ISR_VolumeCallback,
				_ISR_SpeechBeginCallback,
				_ISR_SpeechStopCallback);
		}
		
		[DllImport("__Internal")]
		private static extern void XunFeiVA_ISR_CreateSession();
		public static void ISR_CreateSession()
		{
			XunFeiVA_ISR_CreateSession();
		}

		[DllImport("__Internal")]
		private static extern bool XunFeiVA_ISR_StartRecording();
		public static bool ISR_StartRecording()
		{
			return XunFeiVA_ISR_StartRecording();
		}

		[DllImport("__Internal")]
		private static extern void XunFeiVA_ISR_StopRecording();
		public static void ISR_StopRecording()
		{
			XunFeiVA_ISR_StopRecording();
		}

		[DllImport("__Internal")]
		private static extern void XunFeiVA_ISR_SetupCallbacks(
			internal_ISR_ResultCallback resultCallback,
			internal_ISR_ErrorCallback errorCallback,
			internal_ISR_VolumeCallback volumeCallback,
			internal_ISR_SpeechBeginCallback speechBeginCallback,
			internal_ISR_SpeechStopCallback speechStopCallback);

		[MonoPInvokeCallback(typeof(internal_ISR_ResultCallback))]
		private static void _ISR_ResultCallback(string results, bool isLast)
		{
			if (isrResultEvent != null)
			{
				isrResultEvent(results, isLast);
			}
		}

		[MonoPInvokeCallback(typeof(internal_ISR_ErrorCallback))]
		private static void _ISR_ErrorCallback(int errorCode, int errorType)
		{
			if (isrErrorEvent != null)
			{
				isrErrorEvent(errorCode, errorType);
			}
		}

		[MonoPInvokeCallback(typeof(internal_ISR_VolumeCallback))]
		private static void _ISR_VolumeCallback(int volume)
		{
			if (isrVolumeEvent != null)
			{
				isrVolumeEvent(volume);
			}
		}

		[MonoPInvokeCallback(typeof(internal_ISR_SpeechBeginCallback))]
		private static void _ISR_SpeechBeginCallback()
		{
			if (isrSpeechBeginEvent != null)
			{
				isrSpeechBeginEvent();
			}
		}

		[MonoPInvokeCallback(typeof(internal_ISR_SpeechStopCallback))]
		private static void _ISR_SpeechStopCallback()
		{
			if (isrSpeechStopEvent != null)
			{
				isrSpeechStopEvent();
			}
		}

		#endif
	}
}
