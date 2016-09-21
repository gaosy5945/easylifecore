package com.amarsoft.app.awe.framecase.formatdoc.template01;

import java.lang.reflect.Field;

public class TestFormatDocHelp {

	public static void main(String[] args) {
		try {
			D001_00 one = new D001_00();
			one.initObject();
			
			Class clazz = Class.forName(one.getClass().getName());// 如果有包的话要加上
			Field[] fields = clazz.getDeclaredFields();// 根据Class对象获得属性 私有的也可以获得
			Field.setAccessible(fields, true);
			fields = clazz.getFields();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
