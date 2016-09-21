package com.amarsoft.app.awe.config.worktip;

import java.util.ArrayList;

import com.amarsoft.are.util.json.JSONEncoder;

/**
 * ������ʾ��������<br>
 * ������ʾ��Ϣ�б��ο�{@link WorkTip}��
 * ��ͨ��{@link #getInformation()}��ȡֵ���ݵ��ͻ��ˡ�
 * @author M��Winter
 *
 */
public class WorkTips {

	public final ArrayList<WorkTip> information = new ArrayList<WorkTip>();
	
	/**
	 * ��ȡJSON�ַ������ݵ��ͻ���
	 * @return
	 */
	public String getInformation(){
		return JSONEncoder.encode(information);
	}
}
