function generateUniqueId() {
  return `_${Math.random().toString(36).slice(2, 9)}`;
}

let orders = [];

function addOrder(customerName, items) {
  const id = generateUniqueId();
  const totalPrice = items.reduce((sum, item) => sum + item.price, 0);
  const newOrder = {
    id,
    customerName,
    items,
    totalPrice,
    status: "Menunggu",
  };
  orders.push(newOrder);
}

function updateOrderStatus(orderId, status) {
  const order = orders.find((o) => o.id === orderId);
  if (order) {
    order.status = status;
  }
}

function calculateTotalRevenue() {
  return orders
    .filter((order) => order.status === "Selesai")
    .reduce((sum, order) => sum + order.totalPrice, 0);
}

function deleteOrder(id) {
  const initialLength = orders.length;
  orders = orders.filter((order) => order.id !== id);

  if (orders.length === initialLength) {
  }
}

export {
  orders,
  addOrder,
  updateOrderStatus,
  calculateTotalRevenue,
  deleteOrder,
};
