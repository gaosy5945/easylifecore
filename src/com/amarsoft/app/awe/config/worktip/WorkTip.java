package com.amarsoft.app.awe.config.worktip;

/**
 * ������ʾ�ڵ����
 * @author M��Winter
 *
 */
public class WorkTip {

	private String text;
	private String runner;
	private String action;
	private boolean expand;
	private int num = 1;

	/**
	 * ��ָ������{@link WorkTipRun}����
	 * @param text ��ʾ��Ϣ
	 * @param action ���JS�¼�
	 */
	public WorkTip(String text, String action) {
		this.text = text;
		this.action = action;
	}
	
	/**
	 * ����ʾ��Ϣ��ָ���Ƿ�򿪹���
	 * @param text ��ʾ��Ϣ
	 * @param runner {@link WorkTipRun}
	 * @param action ���JS�¼�
	 */
	public WorkTip(String text, String runner, String action) {
		this(text, action);
		this.runner = runner;
	}

	/**
	 * ����ʾ��Ϣָ���Ƿ�򿪹���
	 * @param text ��ʾ��Ϣ
	 * @param runner {@link WorkTipRun}
	 * @param action ���JS�¼�
	 * @param expand ����ʾ��Ϣ�Ƿ��
	 */
	public WorkTip(String text, String runner, String action, boolean expand) {
		this(text, runner, action);
		this.expand = expand;
	}
	
	/**
	 * ���ñ�ʾ��������Ĭ��Ϊ1
	 * @param num
	 */
	public void setNum(int num) {
		this.num = num;
	}
	
	/**
	 * ��ȡ��ʾ��Ϣ������Ϣ
	 * @return
	 */
	public String getText() {
		return text;
	}
	
	/**
	 * ���ؾ�����ʾ��Ϣ��{@link WorkTipRun}ʵ����·����������
	 * ��ʽ��com.amarsoft.app.awe.config.worktip.WorkTipRun@Key1=Value1~Key2=Value2~...~KeyN=ValueN
	 * @return
	 */
	public String getRunner() {
		return runner;
	}
	
	/**
	 * �����ʾ��Ϣ������JS�¼�
	 * @return
	 */
	public String getAction() {
		return action;
	}
	
	/**
	 * �жϳ�ʼ���Ƿ������ʾ��Ϣ
	 * @return
	 */
	public boolean isExpand() {
		return expand;
	}
	
	/**
	 * ��ȡ��ʾ�ļ���
	 * @return
	 */
	public int getNum() {
		return num;
	}
}
