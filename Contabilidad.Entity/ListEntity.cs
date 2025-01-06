using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace Contabilidad.Entity
{
    [Serializable]
    public class ListEntity<entityType> : IListEntity<entityType> ,IEnumerable
        where entityType : DAC.Ares.Common.Entity.EntityBase
    {
        private IList<entityType> _items;

        #region IList Members

            public ListEntity()
            {
                this._items = new List<entityType>();
            }

            public int Add(entityType item)
            {
                this._items.Add(item);

                return this._items.Count;
            }

            public void Clear()
            {
                this._items.Clear();
            }

            public bool Contains(entityType item)
            {
               return  this._items.Contains(item);
            }

            public int IndexOf(entityType item)
            {
                throw new Exception("The method or operation is not implemented.");
            }

            public void Insert(int index, entityType item)
            {
                this._items.Insert(index, item);
            }

            public bool IsFixedSize
            {
                get
                {
                    return this.IsFixedSize;
                }
            }

            public bool IsReadOnly
            {
                get
                {
                    return this.IsReadOnly;
                }
            }

            public void Remove(entityType item)
            {
                _items.Remove(item);
                //this.Remove(item);It doesn`t work: keep clicling...
            }

            public void RemoveAt(int index)
            {
                this.RemoveAt(index);
            }

            public entityType this[int index]
            {
                get
                {
                    return this._items[index];
                }
                set
                {
                    this._items[index] = value;
                }
            }

        #endregion IList Members

        #region ICollection Members

            public int Count
            {
                get
                {
                    return this._items.Count;
                }
            }

            public bool IsSynchronized
            {
                get
                {
                    return this.IsSynchronized;
                }
            }

        #endregion ICollection Members

        #region IEnumerable Members

            public IEnumerator GetEnumerator()
            {
                return this._items.GetEnumerator();
            }

        #endregion IEnumerable Members
    }
}

public interface IListEntity<entityType>
     where entityType : DAC.Ares.Common.Entity.EntityBase
{
    int Add(entityType item);
    
    void Clear();
    
    bool Contains(entityType item);

    int Count
    {
        get;
    }
    
    System.Collections.IEnumerator GetEnumerator();
    
    int IndexOf(entityType item);
    
    void Insert(int index, entityType item);

    bool IsFixedSize
    {
        get;
    }

    bool IsReadOnly
    {
        get;
    }

    bool IsSynchronized
    {
        get;
    }
    
    void Remove(entityType item);
    
    void RemoveAt(int index);

    entityType this[int index]
    {
        get;
        set;
    }
}