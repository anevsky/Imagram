package com.alexnevsky.webgram.utils;

import java.io.Serializable;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Least Recently Used Cache
 *
 * Discards the least recently used items first
 *
 * @author Alex Nevsky
 */
public class LruCache<A, B> extends LinkedHashMap<A, B> implements Serializable {

	private final int maxEntries;

	public LruCache(final int maxEntries) {
		super(maxEntries + 1, 1.0f, true);
		this.maxEntries = maxEntries;
	}

	/**
	 * Returns <tt>true</tt> if this <code>LruCache</code> has more entries than the maximum specified when it was
	 * created.
	 *
	 * <p>
	 * This method <em>does not</em> modify the underlying <code>Map</code>; it relies on the implementation of
	 * <code>LinkedHashMap</code> to do that, but that behavior is documented in the JavaDoc for
	 * <code>LinkedHashMap</code>.
	 * </p>
	 *
	 * @param eldest
	 *            the <code>Entry</code> in question; this implementation doesn't care what it is, since the
	 *            implementation is only dependent on the size of the cache
	 * @return <tt>true</tt> if the oldest
	 * @see java.util.LinkedHashMap#removeEldestEntry(java.util.Map.Entry)
	 */
	@Override
	protected boolean removeEldestEntry(final Map.Entry<A, B> eldest) {
		return super.size() > maxEntries;
	}
}