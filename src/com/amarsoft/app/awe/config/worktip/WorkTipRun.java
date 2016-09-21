package com.amarsoft.app.awe.config.worktip;

import java.text.DecimalFormat;
import java.util.HashMap;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * ���ݴ��ݵĲ�����ֵ�Ի�ȡ������ʾ�ӿ�
 * @author M��Winter
 *
 */
public interface WorkTipRun {

	DecimalFormat FORMAT = new DecimalFormat("###,##0.00");
	
	/**
	 * ִ�л�ȡ������ʾ��������ת�ع�����ʾ����������{@link WorkTips}
	 * @param params ��ȡ������ʾ�Ĳ������ο�{@link WorkTip#getAction()}�ڶ���ִ�в���
	 * @param CurUser ��ǰ�û�����
	 * @param Sqlca ��������
	 * @return ������ʾ����
	 * @throws Exception 
	 */
	WorkTips run(HashMap<String, String> params, ASUser CurUser, Transaction Sqlca) throws Exception;
}
