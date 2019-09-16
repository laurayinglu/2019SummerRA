class PriorityQueue
{
  public int[] rank;
  public int count;

  public PriorityQueue(int size)
  {
    count = 0;
    rank = new int[size];
  }

  public int parent(int i)
  {
    return (i-1)/2;
  }

  public int leftChild(int parent)
  {
    return 2*parent+1;
  }

  public int rightChild(int parent)
  {
    return leftChild(parent)+1;
  }

  public void bubbleDown(int root)
  {
    if(root >= count)
      return;
    else
    {
      int parent = parent(count-1);
      int leftChild = leftChild(parent);
      int rightChild = rightChild(parent);
      if(rightChild <= count - 1)               // have rightChild
      {
        if(rank[rightChild] < rank[leftChild]) // rightChild is the minimum
        {
          if(rank[rightChild] < rank[parent])
          {
            swap(rank[rightChild], rank[parent]);
            bubbleDown(rightChild);
          }
          else
            return;
        }
        else                                      // leftChild is the minimum
        {
          if(rank[leftChild] < rank[parent])
          {
            swap(rank[leftChild], rank[parent]);
            bubbleDown(leftChild);
          }
          else
            return;
        }
      }
      else                                // no rightChild, means reach to the end of the tree
      {
        if(rank[leftChild] < rank[parent])
        {
          swap(rank[leftChild], rank[parent]);
          //return;
        }

        return;
      }
    }

  }

  public void swap(int a, int b)
  {
    int temp = a;
    a = b;
    b = temp;
  }

  public void bubbleUp(int last)
  {
    // if(count == 2)
    // {
    //   if(rank[0] > rank[1])
    //   {
    //     swap(rank[0], rank[1]);
    //     return;
    //   }
    // }
    if(last < 1)
      return;
    else
    {
      int parent = parent(last-1);
      int leftChild = leftChild(parent);

      int rightChild = rightChild(parent);
      if(rightChild <= count - 1)
      {
        if(rank[rightChild] < rank[leftChild])
        {
          swap(rank[rightChild], rank[leftChild]);
        }
      }

      if(rank[leftChild] < rank[parent])
      {
        swap(rank[leftChild], rank[parent]);
      }

      bubbleUp(parent);
    }
  }

  public int dequeue()
  {
    if(isEmpty())
      throw new IllegalStateException("The priority queue is empty.");
    else if(count >= 2)
    {
      int temp = rank[0];
      rank[0] = rank[count-1]; // move the last element to the 1st

      count -= 1;
      bubbleDown(0);
      return temp;
    }
    else
    {
      count -= 1;
      return rank[0];
    }
  }

  public void enqueue(int num)
  {
      rank[count] = num; // add the new element at the end
      count += 1;
      if(count >= 2)
        bubbleUp(count);
  }

  public boolean isEmpty()
  {
    return count == 0;
  }

}

class Snobbery
{

//  MAIN. Queue them up.

  public static void main(String[] args)
  {
    PriorityQueue queue = new PriorityQueue(100);

    // int[] A = {9,8,7,6,5,4,3,2,1,0};
    // for(int i = 0; i < A.length; i++)
    // {
    //   queue.enqueue(A[i]);
    // }
    queue.enqueue(5);
    queue.enqueue(7);
    queue.enqueue(3);
    queue.enqueue(1);
    //queue.enqueue(6);
    //System.out.println(queue.dequeue());

    // queue.enqueue(90);
    // queue.enqueue(8);
    // queue.enqueue(-2);
    // queue.enqueue(20);
    for(int i = 0; i< queue.count; i += 1)
    {
      System.out.print(queue.rank[i]);
      System.out.print(" ");
    }

    //System.out.println(" ");

    //System.out.println(queue.dequeue());  //  0
    //System.out.println(queue.dequeue());  //  1
    //System.out.println(queue.dequeue());  //  5
    //System.out.println(queue.dequeue());  //  6
    //System.out.println(queue.dequeue());  //  7
    // System.out.println(queue.dequeue());  //
    // System.out.println(queue.dequeue());
    // System.out.println(queue.dequeue());
    // System.out.println(queue.dequeue());



    System.out.println(queue.isEmpty());  //  true        2 points.
  }

}
