package com.amarsoft.app.awe.config.worktip;

/**
 * 工作提示节点对象
 * @author M·Winter
 *
 */
public class WorkTip {

	private String text;
	private String runner;
	private String action;
	private boolean expand;
	private int num = 1;

	/**
	 * 不指定加载{@link WorkTipRun}构造
	 * @param text 提示信息
	 * @param action 点击JS事件
	 */
	public WorkTip(String text, String action) {
		this.text = text;
		this.action = action;
	}
	
	/**
	 * 子提示信息不指定是否打开构造
	 * @param text 提示信息
	 * @param runner {@link WorkTipRun}
	 * @param action 点击JS事件
	 */
	public WorkTip(String text, String runner, String action) {
		this(text, action);
		this.runner = runner;
	}

	/**
	 * 子提示信息指定是否打开构造
	 * @param text 提示信息
	 * @param runner {@link WorkTipRun}
	 * @param action 点击JS事件
	 * @param expand 子提示信息是否打开
	 */
	public WorkTip(String text, String runner, String action, boolean expand) {
		this(text, runner, action);
		this.expand = expand;
	}
	
	/**
	 * 设置表示的条数，默认为1
	 * @param num
	 */
	public void setNum(int num) {
		this.num = num;
	}
	
	/**
	 * 获取提示信息主体信息
	 * @return
	 */
	public String getText() {
		return text;
	}
	
	/**
	 * 加载具体提示信息的{@link WorkTipRun}实现类路径，及参数
	 * 格式如com.amarsoft.app.awe.config.worktip.WorkTipRun@Key1=Value1~Key2=Value2~...~KeyN=ValueN
	 * @return
	 */
	public String getRunner() {
		return runner;
	}
	
	/**
	 * 点击提示信息触发的JS事件
	 * @return
	 */
	public String getAction() {
		return action;
	}
	
	/**
	 * 判断初始化是否打开子提示信息
	 * @return
	 */
	public boolean isExpand() {
		return expand;
	}
	
	/**
	 * 获取表示的件数
	 * @return
	 */
	public int getNum() {
		return num;
	}
}
