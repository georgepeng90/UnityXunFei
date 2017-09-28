using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using XunFeiVA;

public class XunFeiTest : MonoBehaviour 
{
	[SerializeField]
	private Text _text1;

	[SerializeField]
	private Text _text2;

	[SerializeField]
	private Button _button;

	public void StartRecord()
	{
		StartCoroutine(Record());
	}

	void Start()
	{
		StartCoroutine(Setup());
	}

	IEnumerator Setup()
	{
		_button.gameObject.SetActive(false);
		yield return new WaitForEndOfFrame();
		#if !UNITY_EDITOR
		XunFeiVAInterface.isrResultEvent += ResultCallback;
		XunFeiVAInterface.isrVolumeEvent += VolumeCallback;
		XunFeiVAInterface.Init("59bb45ec");
		yield return new WaitForSeconds(2f);
		XunFeiVAInterface.ISR_CreateSession();
		yield return new WaitForSeconds(1f);
		_button.gameObject.SetActive(true);
		#endif
	}

	IEnumerator Record()
	{
		_button.gameObject.SetActive(false);
		_text2.text = "";
		yield return new WaitForEndOfFrame();
		#if !UNITY_EDITOR
		XunFeiVAInterface.ISR_StartRecording();
		yield return new WaitForSeconds(3f);
		XunFeiVAInterface.ISR_StopRecording();
		#endif
		_button.gameObject.SetActive(true);
	}

	private void ResultCallback(string results, bool isLast)
	{
		_text2.text += results;
	}

	private void VolumeCallback(int volume)
	{
		_text1.text = volume.ToString();
	}
}
